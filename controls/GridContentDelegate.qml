import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

ItemDelegate {
    id: control

    property var contents: { }
    property int columns: Math.ceil(__contentModel.length / 2)

    width: ListView.view.width

    checkable: true
    checked: ListView.isCurrentItem
    highlighted: checked

    property var __contentModel: {
        let result = []
        for (let i in control.contents) {
            result.push({
                "name": i,
                "value": control.contents[i],
            })
        }
        return result
    }

    contentItem: GridLayout {
        columns: control.columns

        Repeater {
            model: control.__contentModel

            RowLayout {
                Label {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 1
                    font.bold: true
                    elide: Text.ElideRight
                    text: modelData.name
                }
                Label {
                    Layout.fillWidth: true
                    Layout.preferredWidth: 3
                    elide: Text.ElideRight
                    text: modelData.value
                }
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
