import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Hyprland

import qs.modules.theme

Text {
    id: root

    required property ShellScreen screen

    readonly property bool isFocusedScreen: Hyprland.focusedMonitor === Hyprland.monitorFor(root.screen)

    Layout.maximumWidth: 420

    visible: isFocusedScreen && Hyprland.activeToplevel !== null
    text: Hyprland.activeToplevel ? Hyprland.activeToplevel.title : ""
    color: Colors.subtext
    font.pixelSize: 13
    elide: Text.ElideRight
}
