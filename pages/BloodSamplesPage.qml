import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Blood Samples"

    type: "blood"
    path: "blood"
    attributes: {
        "rfid_id": "string",
        "action": "string",
        "target": "string",
        "origin": "string",
        "strength": "int",
    }
    sortField: "id"

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add Empty"
            onTriggered: page.currentItem = Admin.Builder.emptyBloodSample()
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: page.currentItem = Admin.Builder.randomBloodSample()
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Effect": model.action + " " + model.target,
            "Origin": model.origin,
            "Strength": model.strength,
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

            Item { Layout.fillWidth: true; }

            Button {
                icon.name: "dialog-cancel-symbolic"
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
            placeholderText: "Action"
            text: page.currentItem?.values.action ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Target"
            text: page.currentItem?.values.target ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Strength"
            text: page.currentItem?.values.strength ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Origin"
            text: page.currentItem?.values.origin ?? ""
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
