import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Control {
    id: control

    default property alias contents: contentLayout.data

    property var currentItem
    property bool modified

    signal save()
    signal discard()
    signal remove()

    contentItem: ColumnLayout {
        spacing: 8

        RowLayout {
            Button {
                icon.name: "document-save-symbolic"
                text: "Save"
                flat: true
                enabled: control.modified

                onClicked: control.save()
            }

            Item { Layout.fillWidth: true; }

            Button {
                icon.name: "dialog-cancel-symbolic"
                text: control.modified ? "Discard" : "Close"
                flat: true

                onClicked: control.discard()
            }
        }

        ColumnLayout {
            id: contentLayout
        }

        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

        Button {
            Layout.alignment: Qt.AlignRight
            icon.name: "delete-symbolic"
            text: "Delete"
            flat: true
            onClicked: control.remove()
        }
    }
}
