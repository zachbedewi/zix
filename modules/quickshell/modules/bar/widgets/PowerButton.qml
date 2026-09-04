import QtQuick
import Quickshell
import Quickshell.Hyprland

import qs.modules.components
import qs.modules.theme

Rectangle {
    id: root

    implicitWidth: 22
    implicitHeight: 22
    radius: 6
    color: hoverArea.containsMouse ? Colors.surface : "transparent"

    Text {
        anchors.centerIn: parent
        text: "⏻"
        color: Colors.subtext
        font.pixelSize: 13
    }

    MouseArea {
        id: hoverArea

        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        onClicked: menu.open(root)
    }

    ContextMenu {
        id: menu

        menuItems: [
            { label: "Lock", onTriggered: () => Quickshell.execDetached(["hyprlock"]) },
            { label: "Logout", onTriggered: () => Hyprland.dispatch("exit") },
            { label: "Reboot", onTriggered: () => Quickshell.execDetached(["systemctl", "reboot"]) },
            { label: "Shutdown", onTriggered: () => Quickshell.execDetached(["systemctl", "poweroff"]) }
        ]
    }
}
