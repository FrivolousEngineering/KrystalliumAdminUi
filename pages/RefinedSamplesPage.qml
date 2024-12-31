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
        "primary_action": "string",
        "primary_target": "string",
        "secondary_action": "string",
        "secondary_target": "string",
        "strength": "int",
    }
    sortField: "id"

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add Empty"
            onTriggered: page.currentItem = Admin.Builder.emptyRefinedSample()
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: page.currentItem = Admin.Builder.randomRefinedSample()
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        width: ListView.view.width

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Primary": model.primary_action + " " + model.primary_target,
            "Secondary": model.secondary_action + " " + model.secondary_target,
            "Purity": model.strength,
            "RFID": model.rfid_id
        }
    }

    onCurrentIndexChanged: if (currentIndex >= 0) {
        currentItem = model.get(currentIndex)
    }
    onCurrentItemChanged: if (!currentItem) {
        view.currentIndex = -1
    }

    detailsVisible: currentItem != null
    details: ColumnLayout {
        id: details

        spacing: 8

        RowLayout {
            Button {
                icon.name: "document-save-symbolic"
                text: "Save"
                flat: true

                onClicked: {
                    page.request.execute()
                }
            }

            Item { Layout.fillWidth: true }

            Button {
                icon.name: "edit-delete-remove-symbolic"
                text: "Discard"
                onClicked: page.currentItem = null
                flat: true
            }
        }

        TextField {
            Layout.fillWidth: true
            enabled: false
            placeholderText: "ID"
            text: page.currentItem?.id ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "RFID ID"
            text: page.currentItem?.values.rfid_id ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Primary Action"
            text: page.currentItem?.values.primary_action ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Primary Target"
            text: page.currentItem?.values.primary_target ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Secondary Action"
            text: page.currentItem?.values.secondary_action ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Secondary Target"
            text: page.currentItem?.values.secondary_target ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Purity"
            text: page.currentItem?.values.strength ?? ""
        }

        Item { Layout.fillWidth: true; Layout.fillHeight: true }
    }
}
