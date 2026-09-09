import QtQuick
import Quickshell

QtObject {
    id: root

    readonly property string prefix: ">"

    function query(text) {
        const trimmed = text.trim();
        if (trimmed.length === 0)
            return [];

        return [
            {
                title: trimmed,
                subtitle: "Run command",
                icon: "",
                activate: () => Quickshell.execDetached(["sh", "-c", text])
            }
        ];
    }
}
