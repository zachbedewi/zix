import QtQuick
import Quickshell
import Quickshell.Io

// Gated behind "clip ": clipboard history would otherwise clutter every
// search alongside apps/calculator/web search.
QtObject {
    id: root

    property var entries: []
    readonly property string prefix: "clip "

    // cliphist list prints "<id>\t<preview>" per line; the preview itself
    // may contain further tabs, so only the first one is a delimiter.
    function parseList(text) {
        return text.split("\n").filter(line => line.length > 0).map(line => {
            const tab = line.indexOf("\t");
            return {
                id: line.slice(0, tab),
                preview: line.slice(tab + 1)
            };
        });
    }
    function query(text) {
        // Refreshed on every call (cheap local read) rather than once at
        // startup, so items copied after the shell launched still show up.
        proc.exec(["cliphist", "list"]);

        const needle = text.trim().toLowerCase();
        if (needle.length === 0)
            return root.entries.slice(0, 20).map(root.toResult);

        const prefixMatches = [];
        const substringMatches = [];
        for (const entry of root.entries) {
            const preview = entry.preview.toLowerCase();
            if (preview.startsWith(needle)) {
                prefixMatches.push(entry);
            } else if (preview.includes(needle)) {
                substringMatches.push(entry);
            }
        }

        return prefixMatches.concat(substringMatches).slice(0, 20).map(root.toResult);
    }
    function toResult(entry) {
        return {
            id: `clip:${entry.id}`,
            title: entry.preview,
            subtitle: "Copy to clipboard",
            icon: "",
            activate: () => Quickshell.execDetached(["sh", "-c", `cliphist decode ${entry.id} | wl-copy`])
        };
    }

    Component.onCompleted: proc.exec(["cliphist", "list"])

    property Process proc: Process {
        stdout: StdioCollector {
            onStreamFinished: root.entries = root.parseList(text)
        }
    }
}
