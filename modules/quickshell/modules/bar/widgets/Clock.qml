import QtQuick
import Quickshell

import qs.modules.theme

Text {
    id: root

    SystemClock {
        id: clock
        precision: SystemClock.Minutes
    }

    text: Qt.formatDateTime(clock.date, "ddd d MMM  hh:mm")
    color: Colors.surfaceText
    font.pixelSize: 13
}
