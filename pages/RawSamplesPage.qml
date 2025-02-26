import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.Core as Core
import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Raw Samples"

    type: "raw"
    path: "raw"
    attributes: {
        "rfid_id": "string",
        "positive_action": "action",
        "positive_target": "target",
        "negative_action": "action",
        "negative_target": "target",
        "strength": "int",
    }
    sortField: "id"

    actions: [
        Action {
            text: "Message"
            onTriggered: page.ApplicationWindow.window.messages.show("Test")
        },
        Action {
            icon.name: "document-new-symbolic"
            text: "Add Empty"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.emptyRawSample()
            }
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.randomRawSample()
            }
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Positive": Admin.Effects.actionDisplayString(model.positive_action) + " " + Admin.Effects.targetDisplayString(model.positive_target),
            "Negative": Admin.Effects.actionDisplayString(model.negative_action) + " " + Admin.Effects.targetDisplayString(model.negative_target),
            "Vulgarity": model.strength,
            "RFID": model.rfid_id
        }
    }

    detailsContents: [
        TextField {
            Layout.fillWidth: true
            enabled: false
            placeholderText: "ID"
            text: page.details.currentItem?.id ?? ""
        },

        TextField {
            Layout.fillWidth: true
            placeholderText: "RFID ID"
            text: page.details.currentItem?.values.rfid_id ?? ""

            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("rfid_id", text)
            }
        },

        TextField {
            Layout.fillWidth: true
            placeholderText: "Vulgarity"
            validator: IntValidator { }
            text: page.details.currentItem?.values.strength ?? ""

            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("strength", parseInt(text))
            }
        },

        Label {
            text: "Positive:"
        },

        Controls.ActionComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.positive_action ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("positive_action", currentValue)
            }
        },

        Controls.TargetComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.positive_target ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("positive_target", currentValue)
            }
        },

        Label {
            text: "Negative:"
        },

        Controls.ActionComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.negative_action ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("negative_action", currentValue)
            }
        },

        Controls.TargetComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.negative_target ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("negative_target", currentValue)
            }
        }
    ]
}
