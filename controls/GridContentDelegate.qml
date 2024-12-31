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

        color: delegate.highlighted ? Material.background : (delegate.hovered ? Material.color(Material.Grey, Material.Shade200) : Qt.rgba(1.0, 1.0, 1.0, 0.0))
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
