import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import Krystal.Admin as Admin

import "../controls" as Controls

JsonApiListPage {
    id: page
    title: "Enlisted"

    property var effects: []

    function updateEffects(newEffects) {
        effects = newEffects
        details.modified = true
    }

    function save() {
        let ids = []
        for (let effect of effects) {
            ids.push(effect.id)
        }

        currentItem.setRelationshipValue("effects", ids)
        request.data = currentItem
        request.execute()
    }

    onCurrentItemChanged: effects = Array.from(page.currentItem?.values.effects ?? [])

    type: "enlisted"
    attributes: {
        "name": "string",
        "number": "string",
        "effects": "effectlist",
    }
    relationships: {
        "effects": "effect"
    }

    model: JsonApi.ApiModel {
        path: page.path
        attributes: page.attributes
        relationships: page.relationships

        JsonApi.SortRule {
            field: "id"
            direction: JsonApi.SortRule.Ascending
        }

        JsonApi.IncludeRule {
            field: "effects"
        }
    }

    actions: [
        Action {
            icon.name: "document-new-symbolic"
            text: "Add New"
            onTriggered: page.currentItem = Admin.Builder.emptyEnlisted()
        }
    ]

    delegate: Controls.GridContentDelegate {
        id: delegate

        required property int index
        required property var model

        onClicked: ListView.view.currentIndex = index

        contents: {
            "Name": model.name,
            "Number": model.number,
            "Effects": model.effects.length
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
            placeholderText: "Number"
            text: details.currentItem?.values.number ?? ""

            onTextEdited: {
                page.details.modified = true
                page.details.currentItem.setAttributeValue("number", text)
            }
        },

        Item {
            Layout.fillWidth: true
            implicitHeight: addButton.implicitHeight

            RowLayout {
                anchors.fill: parent

                Label {
                    Layout.leftMargin: 16
                    id: effectsLabel
                    text: "Effects"
                }

                Item {
                    Layout.fillWidth: true
                }

                Button {
                    id: addButton

                    icon.name: "list-add-symbolic"
                    text: "Add"
                    flat: true

                    onClicked: effectDialog.open()
                }

                Button {
                    icon.name: "delete-symbolic"
                    text: "Clear"
                    flat: true

                    onClicked: page.updateEffects([])
                }
            }
        },

        ScrollView {
            id: scrollView

            Layout.fillWidth: true
            Layout.fillHeight: true

            ListView {
                spacing: 8
                currentIndex: -1
                clip: true

                model: page.effects

                delegate: Controls.GridContentDelegate {
                    rightPadding: button.width + button.anchors.rightMargin

                    required property int index
                    required property var modelData

                    checkable: false
                    checked: false
                    hoverEnabled: false

                    columns: width < 500 ? 1 : 2
                    contents: {
                        "Name": modelData.values.name,
                        "Strength": modelData.values.strength,
                        "Action": Admin.Effects.actionDisplayString(modelData.values.action),
                        "Target": Admin.Effects.targetDisplayString(modelData.values.target),
                    }

                    ToolButton {
                        id: button

                        anchors.right: parent.right
                        anchors.rightMargin: scrollView.ScrollBar.vertical.width
                        anchors.verticalCenter: parent.verticalCenter
                        icon.name: "delete-symbolic"

                        onClicked: {
                            let effects = page.effects
                            effects.splice(index, 1)
                            page.updateEffects(effects)
                        }
                    }
                }
            }
        }
    ]

    Controls.EffectDialog {
        id: effectDialog

        onAccepted: {
            let effects = page.effects
            effects.push(selectedEffect)
            page.updateEffects(effects)
        }
    }
}
