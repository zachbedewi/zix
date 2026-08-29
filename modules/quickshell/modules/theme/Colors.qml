pragma Singleton

import QtQuick
import Quickshell
import Quickshell.Io

Singleton {
    id: root

    // readonly property string cachePath: (Quickshell.env("XDG_CACHE_HOME")) + "/zix/colors.json"

    property color background: "#1e1e2e"
    property color surface: "#313244"
    property color surfaceText: "#cdd6f4"
    property color subtext: "#a6adc8"
    property color accent: "#89b4fa"
    property color error: "#f38ba8"
    property color success: "#a6e3a1"

    // FileView {
    //     path: root.cachePath
    //     watchChanges: true
    //     onFileChanged: reload()
    //     onLoaded: {
    //         try {
    //             const c = JSON.parse(text());
    //             if (c.background) {
    //                 root.background = c.background;
    //             }
    //             if (c.surface) {
    //                 root.surface = c.surface;
    //             }
    //             if (c.onSurface) {
    //                 root.surfaceText = c.onSurface;
    //             }
    //             if (c.subtext) {
    //                 root.subtext = c.subtext;
    //             }
    //             if (c.accent) {
    //                 root.accent = c.accent;
    //             }
    //             if (c.error) {
    //                 root.error = c.error;
    //             }
    //             if (c.success) {
    //                 root.success = c.success;
    //             }
    //         } catch (e) {
    //             console.warn("Colors: bad colors.json:", e);
    //         }
    //     }
    // }

    // function alpha(c, a) {
    //     return Qt.rgba(c.r, c.g, c.b, a);
    // }

    // function hover(c) {
    //     return Qt.lighter(c, 1.15);
    // }

    // function pressed(c) {
    //     return Qt.darker(c, 1.1);
    // }
}
