import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import QtQuick.Controls.Material
import QtQuick.Controls.Material.impl

ItemDelegate {
    id: control

    property string subtitle

    width: ListView.view.width

    checkable: true
    checked: ListView.isCurrentItem
    highlighted: checked

    contentItem: ColumnLayout {
        Label {
            text: control.text
            font: control.font
        }
        Label {
            text: control.subtitle
            font: control.font
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
