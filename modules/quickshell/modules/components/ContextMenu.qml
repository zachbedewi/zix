import Quickshell
import Quickshell.Wayland
import QtQuick

PanelWindow {
    // Dock the bar to the top edge of the screen
    anchors.top: true
    anchors.left: true
    anchors.right: true

    // Set the height of the bar in pixels
    implicitHeight: 35

    color: "#1e1e2e"

    // Simple text element to display inside the bar
    Text {
        anchors.centerIn: parent
        text: "Hello from Quickshell!"
        color: "#cdd6f4"
    }
}
