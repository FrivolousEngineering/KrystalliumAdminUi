import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

Page {
    id: page

    property string type
    property alias path: apiModel.path
    property alias attributes: apiModel.attributes
    property alias sortField: sortRule.field
    property alias sortDirection: sortRule.direction

    property ListView view: list
    property alias model: list.model
    property alias currentIndex: list.currentIndex
    property alias delegate: list.delegate

    property alias request: requestObject

    property bool detailsVisible: false
    property Component details

    property var currentItem: null

    property list<Action> actions

    onVisibleChanged: {
        if (visible) {
            apiModel.refresh()
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

            model: JsonApi.ApiModel {
                id: apiModel

                JsonApi.SortRule {
                    id: sortRule;
                    direction: JsonApi.SortRule.Ascending
                }
            }
        }
    }

    Drawer {
        id: detailsBar

        edge: Qt.RightEdge
        modal: false
        interactive: false

        width: visible ? Math.max(ApplicationWindow.window.width * 0.25, 200) : 0
        height: page.height

        leftPadding: 8
        rightPadding: 8

        contentItem: Loader {
            id: detailsLoader

            active: detailsBar.visible && page.details
            sourceComponent: page.details
        }
    }

    background: Item { }

    JsonApi.Request {
        id: requestObject

        method: page.currentItem && page.currentItem.id ? JsonApi.Request.Patch : JsonApi.Request.Post
        path: page.currentItem && page.currentItem.id ? `${page.path}/${page.currentItem.id}` : page.path
        attributes: page.attributes
        data: page.currentItem

        onSuccess: {
            apiModel.refresh()
            detailsBar.close()
        }

        onError: {

        }
    }
}
