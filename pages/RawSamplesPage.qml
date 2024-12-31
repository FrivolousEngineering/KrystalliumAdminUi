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
        "positive_action": "string",
        "positive_target": "string",
        "negative_action": "string",
        "negative_target": "string",
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
            onTriggered: page.currentItem = Admin.Builder.emptyRawSample()
        },
        Action {
            icon.name: "roll-symbolic"
            text: "Generate Random"
            onTriggered: page.currentItem = Admin.Builder.randomRawSample()
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Positive": model.positive_action + " " + model.positive_target,
            "Negative": model.negative_action + " " + model.negative_target,
            "Vulgarity": model.strength,
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
            placeholderText: "Positive Action"
            text: page.currentItem?.values.positive_action ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Positive Target"
            text: page.currentItem?.values.positive_target ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Negative Action"
            text: page.currentItem?.values.negative_action ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Negative Target"
            text: page.currentItem?.values.negative_target ?? ""
        }

        TextField {
            Layout.fillWidth: true
            placeholderText: "Vulgarity"
            text: page.currentItem?.values.strength ?? ""
        }

        Item {
            Layout.fillHeight: true
        }
    }
}
