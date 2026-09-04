import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules.bar.widgets
import qs.modules.theme

PanelWindow {
    id: root

    anchors {
        top: true
        left: true
        right: true
    }

    implicitHeight: 36

    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: Colors.background

        RowLayout {
            id: leftZone
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            anchors.leftMargin: 12
            spacing: 12

            Workspaces {
                screen: root.screen
            }

            ActiveWindow {
                screen: root.screen
            }
        }

        RowLayout {
            id: centerZone
            anchors.centerIn: parent

            Clock {}
        }

        RowLayout {
            id: rightZone
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            anchors.rightMargin: 12
            spacing: 12

            Tray {}

            QuickSettings {}

            PowerButton {}
        }
    }
}
