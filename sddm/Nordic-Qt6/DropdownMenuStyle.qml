import QtQuick 2.15
import QtQuick.Controls 6.0
import org.kde.plasma.core 2.0 as PlasmaCore

Menu {
    id: menuRoot

    background: Rectangle {
        color: "#2e3440"
        border.color: "#232831"
        border.width: 1
        radius: 2
    }

    delegate: MenuItem {
        id: menuItem

        implicitWidth: Math.max(implicitBackgroundWidth + leftInset + rightInset,
                                implicitContentWidth + leftPadding + rightPadding)
        implicitHeight: Math.max(implicitBackgroundHeight + topInset + bottomInset,
                                 implicitContentHeight + topPadding + bottomPadding)

        contentItem: Label {
            text: menuItem.text
            font.pointSize: config.fontSize
            font.family: config.font
            color: menuItem.highlighted ? config.highlight_color : "#d8dee9"
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            leftPadding: units.gridUnit
        }

        background: Rectangle {
            implicitHeight: units.gridUnit * 2
            color: menuItem.highlighted ? config.selected_color : "transparent"
            radius: 2
        }
    }
}
