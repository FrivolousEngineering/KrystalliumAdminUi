import QtQuick
import QtQuick.Controls

import Krystal.Admin as Admin

ComboBox {
    property int value
    onValueChanged: currentIndex = indexOfValue(value)

    model: Admin.Effects.actions

    textRole: "text"
    valueRole: "value"

    displayText: "Action: " + currentText

    Component.onCompleted: currentIndex = indexOfValue(value)
}
