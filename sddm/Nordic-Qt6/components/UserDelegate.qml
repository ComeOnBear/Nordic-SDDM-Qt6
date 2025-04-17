/*
 *   Copyright 2014 David Edmundson <davidedmundson@kde.org>
 *   Copyright 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>
 *   Modified for Qt6 compatibility
 */

import QtQuick 2.15
import QtQuick.Controls 6.0
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

Item {
    id: wrapper

    // If we're using software rendering, draw outlines instead of shadows
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    property alias nameFontSize: usernameDelegate.font.pointSize
    property int fontSize: config.fontSize - 1
    signal clicked()

    property real faceSize: Math.min(width, height - usernameDelegate.height - units.smallSpacing)

    opacity: isCurrent ? 1.0 : 0.5

    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }

    // Draw a translucent background circle under the user picture
    Rectangle {
        anchors.centerIn: imageSource
        width: imageSource.width + 4 // Subtract to prevent fringing
        height: width
        radius: width / 2
        color: "#232831"
    }
    Rectangle {
        anchors.centerIn: imageSource
        width: imageSource.width + 10 // Subtract to prevent fringing
        height: width
        radius: width / 2
        color: "#8fbcbb"
        opacity: 0.6
        z:-1
    }

    Item {
        id: imageSource
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }
        Behavior on width {
            PropertyAnimation {
                from: faceSize
                duration: units.longDuration * 2;
            }
        }
        width: isCurrent ? faceSize : faceSize - units.largeSpacing
        height: width

        //Image takes priority, taking a full path to a file, if that doesn't exist we show an icon
        Image {
            id: face
            source: wrapper.avatarPath
            sourceSize: Qt.size(faceSize, faceSize)
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
        }

        PlasmaCore.IconItem {
            id: faceIcon
            source: iconSource
            visible: (face.status == Image.Error || face.status == Image.Null)
            anchors.fill: parent
            anchors.margins: units.gridUnit * 0.5 // because mockup says so...
            colorGroup: PlasmaCore.ColorScope.colorGroup
        }
    }

    ShaderEffect {
        anchors {
            bottom: usernameDelegate.top
            bottomMargin: units.largeSpacing
            horizontalCenter: parent.horizontalCenter
        }

        width: imageSource.width
        height: imageSource.height

        supportsAtlasTextures: true

        property var source: ShaderEffectSource {
            sourceItem: imageSource
            // software rendering is just a fallback so we can accept not having a rounded avatar here
            hideSource: wrapper.GraphicsInfo.api !== GraphicsInfo.Software
            live: true // otherwise the user in focus will show a blurred avatar
        }

        property var colorBorder: "#00000000"

        //draw a circle with an antialised border
        //innerRadius = size of the inner circle with contents
        //outerRadius = size of the border
        //blend = area to blend between two colours
        //all sizes are normalised so 0.5 == half the width of the texture

        fragmentShader: "
        varying highp vec2 qt_TexCoord0;
        uniform highp float qt_Opacity;
        uniform lowp sampler2D source;

        uniform lowp vec4 colorBorder;
        highp float blend = 0.01;
        highp float innerRadius = 0.47;
        highp float outerRadius = 0.49;
        lowp vec4 colorEmpty = vec4(0.0, 0.0, 0.0, 0.0);

        void main() {
        lowp vec4 colorSource = texture2D(source, qt_TexCoord0.st);

        highp vec2 m = qt_TexCoord0 - vec2(0.5, 0.5);
        highp float dist = sqrt(m.x * m.x + m.y * m.y);

        if (dist < innerRadius)
            gl_FragColor = colorSource;
        else if (dist < innerRadius + blend)
            gl_FragColor = mix(colorSource, colorBorder, ((dist - innerRadius) / blend));
        else if (dist < outerRadius)
            gl_FragColor = colorBorder;
        else if (dist < outerRadius + blend)
            gl_FragColor = mix(colorBorder, colorEmpty, ((dist - outerRadius) / blend));
        else
            gl_FragColor = colorEmpty ;

        gl_FragColor = gl_FragColor * qt_Opacity;
    }
    "
    }

    PlasmaComponents.Label {
        id: usernameDelegate
        font.pointSize: Math.max(fontSize + 2,theme.defaultFont.pointSize + 2)
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight // work around stupid bug in Plasma Components that sets the height
        width: constrainText ? parent.width : implicitWidth
        text: wrapper.name
        style: softwareRendering ? Text.Outline : Text.Normal
        styleColor: softwareRendering ? PlasmaCore.ColorScope.backgroundColor : "transparent" //no outline, doesn't matter
        elide: Text.ElideRight
        horizontalAlignment: Text.AlignHCenter
        color: config.color
        //make an indication that this has active focus, this only happens when reached with keyboard navigation
        font.underline: wrapper.activeFocus
        font.family: config.font
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: wrapper.clicked()
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
