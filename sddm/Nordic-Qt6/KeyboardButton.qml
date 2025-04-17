import QtQuick 2.15
import QtQuick.Controls 6.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmaComponents.ToolButton {
    id: keyboardButton

    property int currentIndex: -1
    property var keyboard // Should be set from parent

    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Keyboard Layout: %1",
                currentIndex >= 0 && currentIndex < keyboard.layouts.length ? keyboard.layouts[currentIndex].shortName : "")

    implicitWidth: minimumWidth
    font.pointSize: config.fontSize
    visible: keyboard && keyboard.layouts.length > 1

    Component.onCompleted: currentIndex = Qt.binding(function() { return keyboard.currentLayout })

    menu: Menu {
        id: keyboardMenu

        Repeater {
            model: keyboard ? keyboard.layouts : []
            delegate: MenuItem {
                text: modelData.longName
                property string shortName: modelData.shortName
                onTriggered: keyboard.currentLayout = index
            }
        }
    }
}
