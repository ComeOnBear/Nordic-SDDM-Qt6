import "components"

import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtQuick.Controls 6.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents

SessionManagementScreen {
    id: root
    property Item mainPasswordBox: passwordBox
    property bool showUsernamePrompt: !showUserList
    property string lastUserName
    property bool loginScreenUiVisible: false
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y

    signal loginRequest(string username, string password)

    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing
    onShowUsernamePromptChanged: if (!showUsernamePrompt) lastUserName = ""

    function startLogin() {
        var username = showUsernamePrompt ? userNameInput.text : userList.selectedUser
        var password = passwordBox.text
        loginButton.forceActiveFocus()
        loginRequest(username, password)
    }

    Input {
        id: userNameInput
        Layout.fillWidth: true
        Layout.topMargin: 10
        Layout.bottomMargin: 10
        text: lastUserName
        visible: showUsernamePrompt
        focus: showUsernamePrompt && !lastUserName
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Username")
        onAccepted: if (root.loginScreenUiVisible) passwordBox.forceActiveFocus()
    }

    Input {
        id: passwordBox
        placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Password")
        focus: !showUsernamePrompt || lastUserName
        echoMode: TextInput.Password
        Layout.fillWidth: true

        onAccepted: if (root.loginScreenUiVisible) startLogin()
        Keys.onEscapePressed: mainStack.currentItem.forceActiveFocus()
        Keys.onPressed: event => {
            if (event.key == Qt.Key_Left && !text) {
                userList.decrementCurrentIndex()
                event.accepted = true
            }
            if (event.key == Qt.Key_Right && !text) {
                userList.incrementCurrentIndex()
                event.accepted = true
            }
        }

        Connections {
            target: sddm
            onLoginFailed: {
                passwordBox.selectAll()
                passwordBox.forceActiveFocus()
            }
        }
    }

    Button {
        id: loginButton
        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Log In")
        enabled: passwordBox.text != ""

        Layout.topMargin: 10
        Layout.bottomMargin: 10
        Layout.preferredWidth: 150
        Layout.alignment: Qt.AlignHCenter | Qt.AlignVCenter

        font.pointSize: config.fontSize
        font.family: config.font

        contentItem: Text {
            text: loginButton.text
            font: loginButton.font
            opacity: enabled ? 1.0 : 0.3
            color: config.highlight_color
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            width: parent.width
            height: parent.height
            radius: width / 2
            color: "#82ABAA"
            opacity: enabled ? 1.0 : 0.3
        }

        onClicked: startLogin()
    }
}
