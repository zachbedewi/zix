import QtQuick
import QtQuick.Effects
import Quickshell
import Quickshell.Wayland

import qs.modules.services

PanelWindow {
    id: unifiedPanel

    required property ShellScreen targetScreen

    Item {
        property real margin: 5

        implicitWidth: child.implicitWidth + margin * 2;
        implicitHeight: child.implicitHeight + margin * 2;

        Rectangle {
            id: child

            x: parent.margin
            y: parent.margin
            width: parent.width - parent.margin * 2
            height: parent.height - parent.margin * 2
        }
    }

    // anchors {
    //     top: true
    //     bottom: true
    //     left: true
    //     right: true
    // }

     color: "transparent"

    // Dynamic keyboard focus: Exclusive when a notch module is open (so text fields work),
    // None otherwise (so compositor receives normal input)
    WlrLayershell.keyboardFocus: {
        return WlrKeyboardFocus.None;
    }
    WlrLayershell.namespace: "zix"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    MouseArea {
        id: backdropArea
        anchors.fill: parent
        z: -1

        onClicked: {
            FocusGrabManager.clearTopGrab();
        }

    }

    Item {
        id: visualContent
        anchors.fill: parent

        layer.enabled: true
    }
}
