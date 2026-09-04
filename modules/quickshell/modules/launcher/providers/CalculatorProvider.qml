import QtQuick
import Quickshell

QtObject {
    id: root

    // Digits, whitespace, and the four basic operators/parens only — this
    // gate runs before Function() ever sees the string, so nothing else
    // (property access, function calls, etc.) can reach the evaluator.
    readonly property var arithmeticPattern: /^[\d\s+\-*/().]+$/

    function query(text) {
        const trimmed = text.trim();
        if (trimmed.length === 0 || !/\d/.test(trimmed) || !root.arithmeticPattern.test(trimmed)) {
            return [];
        }

        let value;
        try {
            value = Function(`"use strict"; return (${trimmed});`)();
        } catch (e) {
            return [];
        }

        if (typeof value !== "number" || !isFinite(value)) return [];

        const display = String(value);
        return [
            {
                title: display,
                subtitle: "Copy to clipboard",
                icon: "",
                activate: () => {
                    Quickshell.clipboardText = display;
                }
            }
        ];
    }
}
