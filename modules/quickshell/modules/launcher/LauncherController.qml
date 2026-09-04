pragma Singleton

import QtQuick
import Quickshell

import qs.modules.launcher.providers

Singleton {
    id: root

    property bool visible: false
    // Compared by name rather than object identity: a ShellScreen read from
    // Quickshell.screens in one place isn't guaranteed to be === one read
    // elsewhere, even for the same output.
    property string targetScreenName: ""
    property string queryText: ""
    property int selectedIndex: 0

    property var providers: [appProvider, calculatorProvider]

    onQueryTextChanged: root.selectedIndex = 0

    readonly property var results: {
        if (root.queryText.trim().length === 0) return [];
        let combined = [];
        for (const provider of root.providers) {
            combined = combined.concat(provider.query(root.queryText));
        }
        return combined.slice(0, 30);
    }

    property AppProvider appProvider: AppProvider {}
    property CalculatorProvider calculatorProvider: CalculatorProvider {}

    function open(screen) {
        root.targetScreenName = screen ? screen.name : "";
        root.queryText = "";
        root.selectedIndex = 0;
        root.visible = true;
    }

    function close() {
        root.visible = false;
    }

    function toggle(screen) {
        if (root.visible) {
            root.close();
        } else {
            root.open(screen);
        }
    }

    function moveSelection(delta) {
        if (root.results.length === 0) return;
        root.selectedIndex = (root.selectedIndex + delta + root.results.length) % root.results.length;
    }

    function activateSelected() {
        const result = root.results[root.selectedIndex];
        if (result) {
            result.activate();
            root.close();
        }
    }
}
