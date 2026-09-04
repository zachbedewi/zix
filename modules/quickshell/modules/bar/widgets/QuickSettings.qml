import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Services.Pipewire
import Quickshell.Services.UPower
import Quickshell.Networking
import Quickshell.Widgets

import qs.modules.theme

RowLayout {
    id: root

    spacing: 10

    // Keeps the default sink's PwNodeAudioIface populated.
    PwObjectTracker {
        objects: Pipewire.defaultAudioSink ? [Pipewire.defaultAudioSink] : []
    }

    Text {
        readonly property var sink: Pipewire.defaultAudioSink

        visible: root.sink !== null
        text: root.sink && root.sink.audio ? (root.sink.audio.muted ? "muted" : Math.round(root.sink.audio.volume * 100) + "%") : ""
        color: Colors.subtext
        font.pixelSize: 12
    }

    Text {
        text: {
            switch (Networking.connectivity) {
            case NetworkConnectivity.Full:
                return "online";
            case NetworkConnectivity.Portal:
            case NetworkConnectivity.Limited:
                return "limited";
            default:
                return "offline";
            }
        }
        color: Colors.subtext
        font.pixelSize: 12
    }

    RowLayout {
        spacing: 4
        visible: UPower.displayDevice !== null && UPower.displayDevice.isPresent

        IconImage {
            implicitSize: 14
            source: UPower.displayDevice && UPower.displayDevice.iconName.length > 0 ? Quickshell.iconPath(UPower.displayDevice.iconName) : ""
        }

        Text {
            text: UPower.displayDevice ? Math.round(UPower.displayDevice.percentage) + "%" : ""
            color: Colors.subtext
            font.pixelSize: 12
        }
    }
}
