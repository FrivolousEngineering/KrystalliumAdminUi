import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Effects"

    type: "effect"
    attributes: {
        "name": "string",
        "action": "action",
        "target": "target",
        "strength": "int",
    }
    sortField: "id"

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add Empty"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.emptyEffect()
            }
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.randomEffect()
            }
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Name": model.name,
            "Strength": model.strength,
            "Action": Admin.Effects.actionDisplayString(model.action),
            "Target": Admin.Effects.targetDisplayString(model.target),
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
            placeholderText: "Name"
            text: page.details.currentItem?.values.name ?? ""

            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("name", text)
            }
        },

        TextField {
            Layout.fillWidth: true
            placeholderText: "Strength"
            text: page.details.currentItem?.values.strength ?? ""
            validator: IntValidator { }
            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("strength", parseInt(text))
            }
        },

        Controls.ActionComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.action ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("action", currentValue)
            }
        },

        Controls.TargetComboBox {
            Layout.fillWidth: true
            value: page.details.currentItem?.values.target ?? 0

            onActivated: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("target", currentValue)
            }
        }
    ]
}
