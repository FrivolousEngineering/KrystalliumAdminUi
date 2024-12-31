import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Zax.JsonApi as JsonApi

Page {
    title: "Overview"

    GridLayout {
        anchors.fill: parent

        columns: 2

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1

            title: "Raw Samples"
        }

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1

            title: "Refined Samples"
        }

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1

            title: "Blood Samples"
        }

        GroupBox {
            Layout.fillWidth: true
            Layout.fillHeight: true
            Layout.preferredWidth: 1

            title: "???"
        }
    }

    background: Item { }
}
