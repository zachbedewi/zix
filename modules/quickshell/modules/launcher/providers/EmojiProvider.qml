import QtQuick
import Quickshell
import Quickshell.Io

// Emoji picker, gated behind ":" like Slack/Discord shortcodes.
QtObject {
    id: root

    property var emoji: []
    property FileView file: FileView {
        path: Quickshell.shellPath("modules/launcher/data/emoji.json")
        printErrors: false

        onLoadFailed: root.emoji = []
        onLoaded: {
            try {
                root.emoji = JSON.parse(text());
            } catch (e) {
                root.emoji = [];
            }
        }
    }
    readonly property string prefix: ":"

    function query(text) {
        const needle = text.trim().toLowerCase();
        if (needle.length === 0) {
            return root.emoji.map(root.toResult);
        }

        const prefixMatches = [];
        const substringMatches = [];
        for (const entry of root.emoji) {
            const shortcode = entry.shortcode.toLowerCase();
            const name = entry.name.toLowerCase();
            if (shortcode.startsWith(needle)) {
                prefixMatches.push(entry);
            } else if (shortcode.includes(needle) || name.includes(needle)) {
                substringMatches.push(entry);
            }
        }

        return prefixMatches.concat(substringMatches).map(root.toResult);
    }
    function toResult(entry) {
        return {
            id: `emoji:${entry.shortcode}`,
            title: `${entry.glyph} ${entry.name}`,
            subtitle: `:${entry.shortcode}:`,
            icon: "",
            activate: () => {
                Quickshell.clipboardText = entry.glyph;
            }
        };
    }
}
