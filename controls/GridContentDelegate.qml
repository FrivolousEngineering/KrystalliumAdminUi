import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

ItemDelegate {
    id: control

    property var contents: { }
    property int columns: -1

    width: ListView.view.width

    checkable: true
    checked: ListView.isCurrentItem
    highlighted: checked

    property var __contentModel: {
        let result = []
        for (let i in control.contents) {
            result.push({
                "text": i + ":",
                "bold": true,
                "fill": false
            })
            result.push({
                "text": control.contents[i],
                "bold": false,
                "fill": true
            })
        }
        return result
    }

    contentItem: GridLayout {
        columns: control.__contentModel.length / 2

        Repeater {
            model: control.__contentModel

            Label {
                Layout.fillWidth: modelData.fill
                text: modelData.text
                font.bold: modelData.bold
            }
        }
    }

    background: Rectangle {
        radius: Material.LargeScale

        color: {
            if (control.highlighted) {
                return Material.background
            }

            if (control.hovered) {
                return Material.color(Material.Grey, Material.Shade300)
            }

            if (control.index % 2 != 0) {
                return Material.color(Material.Grey, Material.Shade100)
            }

            return Material.color(Material.Grey, Material.Shade50)
        }
        Behavior on color { ColorAnimation { duration: 100 } }

        Ripple {
            clip: true
            clipRadius: parent.radius
            width: control.width
            height: control.height
            pressed: control.pressed
            anchor: control
            active: false
            color: control.flat && control.highlighted ? control.Material.highlightedRippleColor : control.Material.rippleColor
        }
    }
}
