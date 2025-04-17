/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *   Modified for Qt6 compatibility
 */

import QtQuick 2.15
import QtQuick.Controls 6.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

PlasmaComponents.ToolButton {
    id: root
    property int currentIndex: -1
    property var sessionModel // Should be provided by parent

    implicitWidth: minimumWidth
    visible: sessionModel && sessionModel.count > 1
    font.pointSize: config.fontSize

    text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Desktop Session: %1",
                currentIndex >= 0 && currentIndex < sessionModel.count ? sessionModel.data(sessionModel.index(currentIndex, 0), Qt.DisplayRole) : "")

    Component.onCompleted: {
        if (sessionModel && sessionModel.hasOwnProperty("lastIndex")) {
            currentIndex = sessionModel.lastIndex
        }
    }

    menu: Menu {
        id: menu

        Repeater {
            model: sessionModel
            delegate: MenuItem {
                text: model.display
                onTriggered: root.currentIndex = model.index
            }
        }
    }
}
