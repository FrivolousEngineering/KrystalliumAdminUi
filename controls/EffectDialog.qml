import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

Dialog {
    id: dialog

    modal: true
    x: (-ApplicationWindow.window?.leftPadding ?? 0) + (Overlay.overlay?.width * 0.125 ?? 0)
    width: (Overlay.overlay?.width * 0.75) ?? 0
    height: (Overlay.overlay?.height * 0.75) ?? 0

    property var selectedEffect

    ScrollView {
        anchors.fill: parent
        ListView {
            id: view

            header: RowLayout {
                width: parent.width

                Button {
                    icon.name: "dialog-cancel-symbolic"
                    text: "Cancel"
                    flat: true
                    onClicked: effectDialog.reject()
                }

                Item { Layout.fillWidth: true }

                Label { text: "Select Effect" }

                Item { Layout.fillWidth: true }

                Button {
                    icon.name: "object-select-symbolic"
                    text: "Select"
                    flat: true
                    enabled: view.currentIndex != -1
                    onClicked: effectDialog.accept()
                }
            }

            model: JsonApi.ApiModel {
                id: effectModel

                path: "effect"
                attributes: {
                    "name": "string",
                    "action": "action",
                    "target": "target",
                    "strength": "int",
                }

                JsonApi.SortRule {
                    field: "id"
                    direction: JsonApi.SortRule.Ascending
                }
            }

            spacing: 8

            delegate: GridContentDelegate {
                required property int index
                required property var model

                contents: {
                    "Name": model.name,
                    "Strength": model.strength,
                    "Action": Admin.Effects.actionDisplayString(model.action),
                    "Target": Admin.Effects.targetDisplayString(model.target),
                }

                onClicked: {
                    dialog.selectedEffect = effectModel.get(index)
                    ListView.view.currentIndex = index
                }

                Material.background: Material.color(Material.Blue, Material.Shade100)
            }
        }
    }
}
