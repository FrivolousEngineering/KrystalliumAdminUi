import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

import "../controls" as Controls

Page {
    id: page

    property string type
    property string path: type
    property var attributes: {}
    property var relationships: {}
    property string sortField
    property int sortDirection: JsonApi.SortRule.Ascending

    property ListView view: list
    property alias model: list.model
    property alias currentIndex: list.currentIndex
    property alias delegate: list.delegate

    property alias request: requestObject

    property bool detailsVisible: currentItem != null
    property Control details: detailsEditor

    property alias detailsContents: detailsEditor.contents

    property var currentItem: null

    property list<Action> actions

    function save() {
        requestObject.data = currentItem
        requestObject.execute()
    }

    function deleteCurrent() {
        deleteRequest.data = currentItem
        deleteRequest.execute()
    }

    onVisibleChanged: {
        if (visible) {
            model.refresh()
        } else {
            detailsBar.close()
        }
    }

    rightPadding: detailsBar.width

    onDetailsVisibleChanged: {
        if (detailsVisible) {
            detailsBar.open()
        } else {
            detailsBar.close()
        }
    }

    onCurrentIndexChanged: {
        if (currentIndex >= 0) {
            currentItem = model.get(currentIndex)
        }
    }
    onCurrentItemChanged: {
        if (!currentItem) {
            view.currentIndex = -1
        }
    }

    header: RowLayout {
        Item { Layout.fillWidth: true; Layout.fillHeight: true }

        Repeater {
            model: page.actions
            Button {
                flat: true
                action: modelData
            }
        }

        Item { Layout.preferredWidth: page.rightPadding; Layout.fillHeight: true }
    }

    ScrollView {
        anchors.fill: parent
        anchors.leftMargin: 4
        anchors.rightMargin: 4

        ListView {
            id: list

            spacing: 8

            model: JsonApi.ApiModel {
                id: apiModel

                path: page.path
                attributes: page.attributes
                relationships: page.relationships

                JsonApi.SortRule {
                    id: sortRule;
                    field: page.sortField
                    direction: page.sortDirection
                }
            }
        }
    }

    Drawer {
        id: detailsBar

        edge: Qt.RightEdge
        modal: false
        interactive: false

        width: visible ? Math.max(ApplicationWindow.window.width * 0.4, 400) : 0
        height: page.height

        leftPadding: 8
        rightPadding: 8

        contentItem: Controls.Editor {
            id: detailsEditor

            currentItem: page.currentItem

            onSave: page.save()
            onDiscard: page.currentItem = null
        }
    }

    background: Item { }

    JsonApi.Request {
        id: requestObject

        method: page.currentItem && page.currentItem.id ? JsonApi.Request.Patch : JsonApi.Request.Post
        path: page.currentItem && page.currentItem.id ? `${page.path}/${page.currentItem.id}` : page.path
        attributes: page.attributes

        onSuccess: {
            page.ApplicationWindow.window.messages.show("Save successful")
            page.model.refresh()
            detailsBar.close()
            page.currentIndex = -1
            page.currentItem = null
        }

        onError: {
            page.ApplicationWindow.window.messages.show("Error encountered while saving: " + errorString)
        }
    }

    JsonApi.Request {
        id: deleteRequest

        method: JsonApi.Request.Delete
        path: page.currentItem ? `${page.path}/${page.currentItem.id}` : ""
        attributes: page.attributes

        onSuccess: {
            page.model.refresh()
            detailsBar.close()
        }
    }
}
