import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.SystemTray
import Quickshell.Widgets

RowLayout {
    id: root

    spacing: 8

    Repeater {
        model: SystemTray.items

        IconImage {
            id: trayIcon

            required property SystemTrayItem modelData

            implicitSize: 16
            source: Quickshell.iconPath(trayIcon.modelData.icon)

            MouseArea {
                anchors.fill: parent
                acceptedButtons: Qt.LeftButton | Qt.RightButton
                cursorShape: Qt.PointingHandCursor
                onClicked: mouse => {
                    if (mouse.button === Qt.LeftButton) {
                        trayIcon.modelData.activate();
                    } else {
                        trayIcon.modelData.secondaryActivate();
                    }
                }
            }
        }
    }
}
