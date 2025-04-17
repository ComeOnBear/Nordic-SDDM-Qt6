/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *   Modified for Qt6 compatibility
 */

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 6.0
import org.kde.plasma.core 2.0

RowLayout {
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    Label {
        text: Qt.formatDate(timeSource.data["Local"]["DateTime"], Qt.DefaultLocaleLongDate)
        color: config.color
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 11
        Layout.alignment: Qt.AlignHCenter
        font.family: config.font
    }

    Label {
        text: Qt.formatTime(timeSource.data["Local"]["DateTime"])
        color: config.color
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        font.pointSize: 11
        Layout.alignment: Qt.AlignHCenter
        font.family: config.font
    }

    DataSource {
        id: timeSource
        engine: "time"
        connectedSources: ["Local"]
        interval: 1000
    }
}
