import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.modules.theme

RowLayout {
    id: root

    required property ShellScreen screen

    readonly property HyprlandMonitor monitor: Hyprland.monitorFor(root.screen)

    spacing: 6

    Repeater {
        model: Hyprland.workspaces

        Rectangle {
            id: pill

            required property HyprlandWorkspace modelData

            visible: modelData.monitor === root.monitor

            implicitWidth: 22
            implicitHeight: 22
            radius: 6
            color: modelData.focused ? Colors.accent : (modelData.urgent ? Colors.error : Colors.surface)

            Text {
                anchors.centerIn: parent
                text: pill.modelData.name
                color: pill.modelData.focused ? Colors.background : Colors.subtext
                font.pixelSize: 11
            }

            MouseArea {
                anchors.fill: parent
                cursorShape: Qt.PointingHandCursor
                onClicked: pill.modelData.activate()
            }
        }
    }
}
