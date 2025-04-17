import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 6.0

TextField {
    placeholderTextColor: config.color
    color: config.color
    font.pointSize: config.fontSize
    font.family: config.font

    background: Rectangle {
        color: "#2e3440"
        border.color: parent.activeFocus ? config.selected_color : "#2e3440"
        radius: 10
        width: parent.width
        height: width / 9
        opacity: 0.85
        anchors.centerIn: parent
    }
}
