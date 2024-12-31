import QtQuick.Controls
import QtQuick.Layouts

import Zax.Core as Core
import Zax.JsonApi as JsonApi

Page {
    id: page

    ColumnLayout {
        anchors.centerIn: parent
        width: parent.width * 0.5

        Label {
            text: "Login"
            font.pointSize: 24
        }

        Label {
            text: "Server:"
        }

        TextField {
            id: serverField
            Layout.fillWidth: true
            text: Core.CommandLineParser.server
            onAccepted: nextItemInFocusChain().focus = true
        }

        Label {
            text: "Path:"
        }

        TextField {
            id: pathField
            Layout.fillWidth: true
            text: Core.CommandLineParser.path
            onAccepted: nextItemInFocusChain().focus = true
        }

        Label {
            text: "Username:"
        }

        TextField {
            id: userNameField
            Layout.fillWidth: true
            text: Core.CommandLineParser.username
            onAccepted: nextItemInFocusChain().focus = true
        }

        Label {
            text: "Password"
        }

        TextField {
            id: passwordField
            Layout.fillWidth: true
            text: Core.CommandLineParser.password
            onAccepted: nextItemInFocusChain().focus = true
        }

        Button {
            Layout.fillWidth: true

            text: "Connect"

            enabled: !settings.connected

            onClicked: {
                settings.started = false
                settings.userName = userNameField.text
                settings.password = passwordField.text
                settings.servers = [serverField.text]
                settings.path = pathField.text
                settings.started = true
            }
        }
    }

    JsonApi.ApiSettings {
        id: settings

        onConnectedChanged: {
            if (connected) {
                page.ApplicationWindow.window.state = Core.ApplicationState.Operational
            }
        }
    }
}
