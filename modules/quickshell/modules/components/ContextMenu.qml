import QtQuick
import QtQuick.Layouts
import Quickshell

import qs.modules.theme

// Reusable anchored popup menu (power menu, future tray/quick-settings
// click-menus). Dismissal on outside click / focus loss comes from the
// native Wayland popup grab (grabFocus), not FocusGrabManager — that
// singleton exists to route clicks through a fullscreen backdrop item
// (see UnifiedShellPanel), which a small anchored popup doesn't have.
PopupWindow {
    id: root

    property Item anchorItem
    property var menuItems: []

    function open(item) {
        root.anchorItem = item;
        root.visible = true;
    }

    function close() {
        root.visible = false;
    }

    anchor.item: root.anchorItem
    anchor.edges: Edges.Bottom | Edges.Right
    anchor.gravity: Edges.Bottom | Edges.Left
    anchor.adjustment: PopupAdjustment.Flip

    grabFocus: true
    visible: false
    color: "transparent"

    implicitWidth: column.implicitWidth + 16
    implicitHeight: column.implicitHeight + 16

    Rectangle {
        anchors.fill: parent
        color: Colors.surface
        radius: 8
        border.width: 1
        border.color: Colors.background

        ColumnLayout {
            id: column

            anchors.fill: parent
            anchors.margins: 8
            spacing: 2

            Repeater {
                model: root.menuItems

                Rectangle {
                    id: entry

                    required property var modelData

                    Layout.fillWidth: true
                    implicitWidth: label.implicitWidth + 16
                    implicitHeight: 28
                    radius: 4
                    color: hoverArea.containsMouse ? Colors.accent : "transparent"

                    Text {
                        id: label

                        anchors.left: parent.left
                        anchors.leftMargin: 8
                        anchors.verticalCenter: parent.verticalCenter
                        text: entry.modelData.label
                        color: hoverArea.containsMouse ? Colors.background : Colors.surfaceText
                    }

                    MouseArea {
                        id: hoverArea

                        anchors.fill: parent
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            entry.modelData.onTriggered();
                            root.close();
                        }
                    }
                }
            }
        }
    }
}
