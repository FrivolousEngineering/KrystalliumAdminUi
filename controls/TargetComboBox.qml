import QtQuick
import QtQuick.Controls

import Krystal.Admin as Admin

ComboBox {
    property int value
    onValueChanged: currentIndex = indexOfValue(value)

    model: Admin.Effects.targets

    textRole: "text"
    valueRole: "value"

    displayText: "Target: " + currentText

    Component.onCompleted: currentIndex = indexOfValue(value)
}

