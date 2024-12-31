pragma ComponentBehavior: Bound

import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material

import Zax.Core as Core

Core.Application {
    id: application

    title: "Krystallium Admin" + (currentItem.title ? " - %1".arg(currentItem.title) : "")

    width: 1280
    height: 720

    Material.accent: Material.Blue
    Material.primary: Material.color(Material.Blue, Material.Shade300)
    Material.foreground: Material.color(Material.Grey, Material.Shade900)
    Material.background: Material.color(Material.Blue, Material.Shade50)

    color: "white"

    states: [
        Core.ApplicationState {
            page: Qt.resolvedUrl("pages/ConnectPage.qml")
            state: Core.ApplicationState.Opening
            skip: Core.CommandLineParser.autoconnect
        },
        Core.ApplicationState {
            page: Qt.resolvedUrl("pages/RawSamplesPage.qml")
            state: Core.ApplicationState.Operational
        }
    ]

    property string currentPage: Qt.resolvedUrl("pages/RawSamplesPage.qml")
    property bool controlsVisible: stack.currentItem?.controlsVisible ?? true

    onCurrentPageChanged: {
        stack.replace(currentPage)
    }

    leftPadding: sidebar.visible ? sidebar.width : 0

    Drawer {
        id: sidebar

        visible: application.state == Core.ApplicationState.Operational && application.controlsVisible
        modal: false
        interactive: false
        edge: Qt.LeftEdge

        width: application.width * 0.2
        height: parent.height

        ColumnLayout {
            anchors.fill: parent
            anchors.leftMargin: 4
            anchors.rightMargin: 4

            spacing: 0

            Item { Layout.fillWidth: true; Layout.fillHeight: true }

            Repeater {
                model: [
                    // { name: "Overview", page: Qt.resolvedUrl("pages/OverviewPage.qml") },
                    { name: "Raw Samples", page: Qt.resolvedUrl("pages/RawSamplesPage.qml") },
                    { name: "Refined Samples", page: Qt.resolvedUrl("pages/RefinedSamplesPage.qml") },
                    { name: "Blood Samples", page: Qt.resolvedUrl("pages/BloodSamplesPage.qml") },
                    // { name: "Flows", page: Qt.resolvedUrl("pages/FlowsPage.qml") },
                    // { name: "Devices", page: Qt.resolvedUrl("pages/DevicesPage.qml") },
                    // { name: "Settings", page: Qt.resolvedUrl("pages/SettingsPage.qml") },
                ]

                Button {
                    id: button

                    required property var modelData

                    Layout.fillWidth: true

                    text: modelData.name

                    checkable: true
                    checked: application.currentPage == modelData.page
                    highlighted: checked
                    flat: true

                    onClicked: {
                        application.currentPage = modelData.page
                    }

                    contentItem: Label {
                        text: button.text
                        verticalAlignment: Text.AlignVCenter
                    }
                }
            }

            Item { Layout.fillWidth: true; Layout.fillHeight: true }
        }
    }
}
