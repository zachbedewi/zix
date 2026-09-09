import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property string defaultBase: "https://duckduckgo.com/?q="
    readonly property var engines: [
        {
            bang: "g",
            label: "Google",
            base: "https://www.google.com/search?q="
        },
        {
            bang: "yt",
            label: "YouTube",
            base: "https://www.youtube.com/results?search_query="
        },
        {
            bang: "gh",
            label: "GitHub",
            base: "https://github.com/search?q="
        }
    ]

    // Always-on: falls back to a default engine when no bang matches, so
    // web search always contributes exactly one result alongside
    // apps/calculator.
    readonly property string prefix: ""

    function query(text) {
        const trimmed = text.trim();

        for (const engine of root.engines) {
            const marker = engine.bang + " ";
            if (trimmed.startsWith(marker)) {
                const term = trimmed.slice(marker.length).trim();
                return [root.result(engine.bang, engine.base, term, `Search ${engine.label} for '${term}'`)];
            }
        }

        return [root.result("ddg", root.defaultBase, trimmed, `Search the web for '${trimmed}'`)];
    }
    function result(bang, base, term, title) {
        return {
            id: `websearch:${bang}:${term}`,
            title: title,
            subtitle: "Open in browser",
            icon: "",
            activate: () => Quickshell.execDetached(["xdg-open", base + encodeURIComponent(term)])
        };
    }
}
