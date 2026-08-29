import QtQuick
import QtQuick.Layouts
import Quickshell

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
            anchors.fill: parent
            anchors.leftMargin: 12
            anchors.rightMargin: 12
        }
    }
}
