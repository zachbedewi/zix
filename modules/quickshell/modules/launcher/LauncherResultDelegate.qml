import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.modules.theme

Rectangle {
    id: root

    required property var resultData
    required property bool selected

    implicitHeight: 44
    radius: 6
    color: root.selected ? Colors.accent : "transparent"

    RowLayout {
        anchors.fill: parent
        anchors.margins: 8
        spacing: 10

        IconImage {
            implicitSize: 26
            source: root.resultData.icon.length > 0 ? Quickshell.iconPath(root.resultData.icon) : ""
        }

        ColumnLayout {
            Layout.fillWidth: true
            spacing: 0

            Text {
                Layout.fillWidth: true
                text: root.resultData.title
                color: root.selected ? Colors.background : Colors.surfaceText
                elide: Text.ElideRight
                font.pixelSize: 14
            }

            Text {
                Layout.fillWidth: true
                visible: text.length > 0
                text: root.resultData.subtitle ?? ""
                color: root.selected ? Colors.background : Colors.subtext
                elide: Text.ElideRight
                font.pixelSize: 11
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            root.resultData.activate();
            LauncherController.close();
        }
    }
}
