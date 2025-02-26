import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Refined Samples"

    type: "refined"
    path: "refined"
    attributes: {
        "rfid_id": "string",
        "primary_action": "action",
        "primary_target": "target",
        "secondary_action": "action",
        "secondary_target": "target",
        "strength": "int",
    }
    sortField: "id"

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add Empty"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.emptyRefinedSample()
            }
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.randomRefinedSample()
            }
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        width: ListView.view.width

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Primary": Admin.Effects.actionDisplayString(model.primary_action) + " " + Admin.Effects.targetDisplayString(model.primary_target),
            "Secondary": Admin.Effects.actionDisplayString(model.secondary_action) + " " + Admin.Effects.targetDisplayString(model.secondary_target),
            "Purity": model.strength,
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
            placeholderText: "Purity"
            validator: IntValidator { }
            text: page.details.currentItem?.values.strength ?? ""

            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("strength", parseInt(text))
            }
        },

        Label {
            text: "Primary:"
        },

        Controls.ActionComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.primary_action ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("primary_action", currentValue)
            }
        },

        Controls.TargetComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.primary_target ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("primary_target", currentValue)
            }
        },

        Label {
            text: "Secondary:"
        },

        Controls.ActionComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.secondary_action ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("secondary_action", currentValue)
            }
        },

        Controls.TargetComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.secondary_target ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("secondary_target", currentValue)
            }
        }
    ]
}
