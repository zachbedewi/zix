import QtQuick
import QtQuick.Layouts

import qs.modules.theme

// Instantiated fresh each time the launcher opens (see UnifiedShellPanel's
// Loader), so there's no stale query text or selection to reset by hand.
Rectangle {
    id: root

    color: Colors.surface
    radius: 10
    border.width: 1
    border.color: Colors.background

    implicitWidth: 560
    implicitHeight: column.implicitHeight + 24

    Component.onCompleted: input.forceActiveFocus()

    ColumnLayout {
        id: column

        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Rectangle {
            id: inputBox

            Layout.fillWidth: true
            implicitHeight: 40
            radius: 8
            color: Colors.background

            TextInput {
                id: input

                anchors.fill: parent
                anchors.margins: 10
                color: Colors.surfaceText
                font.pixelSize: 15
                selectByMouse: true
                text: LauncherController.queryText

                onTextChanged: LauncherController.queryText = text

                Keys.onDownPressed: LauncherController.moveSelection(1)
                Keys.onUpPressed: LauncherController.moveSelection(-1)
                Keys.onReturnPressed: LauncherController.activateSelected()
                Keys.onEscapePressed: LauncherController.close()
            }

            Text {
                anchors.left: input.left
                anchors.verticalCenter: input.verticalCenter
                text: "Search apps, run a calculation…"
                color: Colors.subtext
                font.pixelSize: 15
                visible: input.text.length === 0
            }
        }

        ListView {
            id: resultList

            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 360)
            clip: true
            spacing: 2
            model: LauncherController.results

            delegate: LauncherResultDelegate {
                required property var modelData
                required property int index

                width: resultList.width
                resultData: modelData
                selected: index === LauncherController.selectedIndex
            }
        }
    }
}
