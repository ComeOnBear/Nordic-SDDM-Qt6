/*
 *   Copyright 2016 Kai Uwe Broulik <kde@privat.broulik.de>
 *   Modified for Qt6 compatibility
 */

import QtQuick 2.15
import QtQuick.Controls 6.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents
import org.kde.plasma.workspace.components 2.0 as PW

Row {
    spacing: units.smallSpacing
    visible: pmSource.data["Battery"]["Has Cumulative"]

    PlasmaCore.DataSource {
        id: pmSource
        engine: "powermanagement"
        connectedSources: ["Battery", "AC Adapter"]
    }

    PW.BatteryIcon {
        id: battery
        hasBattery: pmSource.data["Battery"]["Has Battery"] || false
        percent: pmSource.data["Battery"]["Percent"] || 0
        pluggedIn: pmSource.data["AC Adapter"] ? pmSource.data["AC Adapter"]["Plugged in"] : false

        height: batteryLabel.height
        width: height
    }

    PlasmaComponents.Label {
        id: batteryLabel
        height: undefined
        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel","%1%", battery.percent)
        Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Battery at %1%", battery.percent)
    }
}
