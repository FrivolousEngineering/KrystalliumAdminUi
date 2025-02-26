import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Blood Samples"

    property var currentEffect: {}

    onCurrentItemChanged: currentEffect = currentItem?.values?.effect ?? {}

    type: "blood"
    attributes: {
        "rfid_id": "string",
        "strength": "int",
        "effect": "effect",
    }
    relationships: {
        "effect": "effect"
    }

    model: JsonApi.ApiModel {
        path: "blood"
        attributes: page.attributes
        relationships: page.relationships

        JsonApi.SortRule {
            field: "id"
            direction: JsonApi.SortRule.Ascending
        }

        JsonApi.IncludeRule {
            field: "effect"
        }
    }

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add New"
            onTriggered: {
                page.details.modified = true
                page.currentItem = Admin.Builder.emptyBloodSample()
            }
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        contents: {
            "RFID": model.rfid_id || "None",
            "Effect Name": model.effect.values.name,
            "Effect": Admin.Effects.actionDisplayString(model.effect.values.action) + " " + Admin.Effects.targetDisplayString(model.effect.values.target),
            "Strength": model.strength,
        }

        onClicked: ListView.view.currentIndex = index
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
            placeholderText: "Strength"
            validator: IntValidator { }
            text: page.details.currentItem?.values.strength ?? ""
            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("strength", parseInt(text))
            }
        },

        Label {
            text: "Effect:"
        },

        Controls.GridContentDelegate {
            Layout.fillWidth: true
            width: 0

            checkable: false
            checked: false

            columns: width < 500 ? 1 : 2
            contents: {
                "Name": page.currentEffect?.values?.name ?? "",
                "Action": Admin.Effects.actionDisplayString(page.currentEffect?.values?.action ?? 0),
                "Target": Admin.Effects.targetDisplayString(page.currentEffect?.values?.target ?? 0),
            }

            onClicked: effectDialog.open()
        }
    ]

    Controls.EffectDialog {
        id: effectDialog

        onAccepted: {
            page.details.modified = true
            page.currentEffect = selectedEffect
            page.currentItem.setRelationshipValue("effect", selectedEffect.id)
        }
    }
}
