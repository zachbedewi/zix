import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Widgets

import qs.modules.theme

Rectangle {
    id: root

    // A selected/confirm-pending row needs light text on a dark row and
    // vice versa; both states share the same contrast treatment.
    readonly property bool highlighted: root.selected || root.resultData.confirmPending
    required property int index
    required property var resultData
    required property bool selected

    color: root.resultData.confirmPending ? Colors.error : (root.selected ? Colors.accent : "transparent")
    implicitHeight: 44
    radius: 6

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
                color: root.highlighted ? Colors.background : Colors.surfaceText
                elide: Text.ElideRight
                font.pixelSize: 14
                text: root.resultData.title
            }
            Text {
                Layout.fillWidth: true
                color: root.highlighted ? Colors.background : Colors.subtext
                elide: Text.ElideRight
                font.pixelSize: 11
                text: root.resultData.subtitle ?? ""
                visible: text.length > 0
            }
        }
    }
    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor

        onClicked: {
            LauncherController.selectedIndex = root.index;
            LauncherController.activateSelected();
        }
    }
}
