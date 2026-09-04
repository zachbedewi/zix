import QtQuick
import Quickshell
import Quickshell.Wayland

import qs.modules.launcher
import qs.modules.services

// Fullscreen, transparent overlay host: a backdrop that catches outside
// clicks (dismissing via FocusGrabManager) with real content positioned
// within it. Currently only the launcher dropdown; future overlay-style
// modules (notifications, OSD) should be able to share this instead of
// each declaring their own layer-shell surface.
PanelWindow {
    id: unifiedPanel

    // A private copy of which screen this instance belongs to, set once
    // from shell.qml's Variants and mirrored into `screen` below. `visible`
    // compares against this rather than reading `screen` back directly —
    // doing that caused a binding loop, presumably from Quickshell's own
    // window-placement logic touching `screen` once the surface maps.
    property ShellScreen hostScreen

    screen: unifiedPanel.hostScreen

    anchors {
        top: true
        bottom: true
        left: true
        right: true
    }

    visible: LauncherController.visible && LauncherController.targetScreenName === unifiedPanel.hostScreen.name

    color: "transparent"

    // Exclusive when the launcher is open (so its search field works),
    // None otherwise (so the compositor receives normal input).
    WlrLayershell.keyboardFocus: unifiedPanel.visible ? WlrKeyboardFocus.Exclusive : WlrKeyboardFocus.None
    WlrLayershell.namespace: "launcher"
    WlrLayershell.layer: WlrLayer.Overlay
    exclusionMode: ExclusionMode.Ignore

    MouseArea {
        id: backdropArea

        anchors.fill: parent
        z: -1

        onClicked: FocusGrabManager.clearTopGrab()
    }

    FocusGrab {
        active: unifiedPanel.visible
        onCleared: LauncherController.close()
    }

    Item {
        id: visualContent

        anchors.fill: parent
        layer.enabled: true

        Loader {
            id: launcherLoader

            anchors.horizontalCenter: parent.horizontalCenter
            y: 48
            active: unifiedPanel.visible
            sourceComponent: LauncherPanel {}
        }
    }
}
