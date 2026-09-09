import QtQuick
import QtQuick.Layouts

import qs.modules.theme

// Instantiated fresh each time the launcher opens (see UnifiedShellPanel's
// Loader), so there's no stale query text or selection to reset by hand.
Rectangle {
    id: root

    border.color: Colors.background
    border.width: 1
    color: Colors.surface
    implicitHeight: column.implicitHeight + 24
    implicitWidth: 560
    radius: 10

    Component.onCompleted: input.forceActiveFocus()

    ColumnLayout {
        id: column

        anchors.fill: parent
        anchors.margins: 12
        spacing: 8

        Rectangle {
            id: inputBox

            Layout.fillWidth: true
            color: Colors.background
            implicitHeight: 40
            radius: 8

            TextInput {
                id: input

                anchors.fill: parent
                anchors.margins: 10
                color: Colors.surfaceText
                font.pixelSize: 15
                selectByMouse: true
                text: LauncherController.queryText

                Keys.onDownPressed: LauncherController.moveSelection(1)
                Keys.onEscapePressed: LauncherController.cancelConfirmOrClose()
                Keys.onReturnPressed: LauncherController.activateSelected()
                Keys.onUpPressed: LauncherController.moveSelection(-1)
                onTextChanged: LauncherController.queryText = text
            }
            Text {
                anchors.left: input.left
                anchors.verticalCenter: input.verticalCenter
                color: Colors.subtext
                font.pixelSize: 15
                text: LauncherController.placeholderHint
                visible: input.text.length === 0
            }
        }
        ListView {
            id: resultList

            Layout.fillWidth: true
            Layout.preferredHeight: Math.min(contentHeight, 360)
            clip: true
            model: LauncherController.results
            spacing: 2

            delegate: LauncherResultDelegate {
                required property var modelData

                resultData: modelData
                selected: index === LauncherController.selectedIndex
                width: resultList.width
            }
        }
    }
}
