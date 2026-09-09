import QtQuick
import Quickshell
import Quickshell.Io

// Gated behind "/": shells out to `locate` per query, so it only runs when
// the user's explicitly asking for a file rather than on every keystroke
// alongside apps/calculator/web search.
QtObject {
    id: root

    property string activeQuery: ""
    property var lastResults: []
    readonly property string prefix: "/"

    function query(text) {
        const trimmed = text.trim();
        if (trimmed.length === 0) {
            root.activeQuery = "";
            root.lastResults = [];
            return [];
        }

        // query() reruns for reasons unrelated to the search text (e.g.
        // frecency scores changing elsewhere), so only kick off a fresh
        // locate call when the text itself actually changed. exec() stops
        // any still-running invocation before starting the new one, rather
        // than letting them pile up.
        if (trimmed !== root.activeQuery) {
            root.activeQuery = trimmed;
            root.lastResults = [];
            proc.exec(["locate", "--ignore-case", "--limit", "20", trimmed]);
        }

        return root.lastResults;
    }

    property Process proc: Process {
        stdout: StdioCollector {
            onStreamFinished: {
                const paths = text.split("\n").filter(line => line.length > 0);
                root.lastResults = paths.map(path => ({
                            id: `file:${path}`,
                            title: path.slice(path.lastIndexOf("/") + 1),
                            subtitle: path,
                            icon: "",
                            activate: () => Quickshell.execDetached(["xdg-open", path])
                        }));
            }
        }
    }
}
