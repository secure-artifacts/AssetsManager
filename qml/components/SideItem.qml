import QtQuick
import QtQuick.Controls

Rectangle {
    id: sideItemRoot
    property int groupId: -1
    property string icon: ""
    property string iconColor: "#7A7A90"
    property alias label: itemLabel.text
    property int countBadge: -1
    property int indentLevel: 0
    signal itemClicked()
    signal expandClicked()

    width: parent ? parent.width : 200; height: 34
    color: itemMa.containsMouse ? "#1E1E2E" : "transparent"
    radius: 6
    Behavior on color { ColorAnimation { duration: 100 } }

    Menu {
        id: itemContextMenu
        MenuItem { text: "重命名"; onTriggered: renameGroupDlg.open() }
        MenuItem { text: "删除分组"; onTriggered: deleteGroupDlg.open() }
    }

    SimpleInputDialog {
        id: renameGroupDlg
        title: "重命名分组"
        placeholder: "新名称…"
        onInputAccepted: (text) => tagController.renameGroup(groupId, text)
    }

    Dialog {
        id: deleteGroupDlg
        title: "确认删除"
        modal: true; anchors.centerIn: Overlay.overlay
        width: 300
        standardButtons: Dialog.Yes | Dialog.No
        onAccepted: tagController.deleteGroup(groupId)
        Text { padding: 20; text: "确定要删除分组 「" + label + "」 吗？\n(素材不会被删除)"; color: "#E4E4EA" }
    }

    Row {
        anchors {
            left: parent.left; leftMargin: 12 + indentLevel * 16
            verticalCenter: parent.verticalCenter
        }
        spacing: 8
        Text {
            text: icon; color: iconColor
            font.pixelSize: 10
            anchors.verticalCenter: parent.verticalCenter
            visible: icon !== ""
            MouseArea {
                anchors.fill: parent
                onClicked: (mouse) => {
                    mouse.accepted = true
                    sideItemRoot.expandClicked()
                }
            }
        }
        Text {
            id: itemLabel
            color: "#C0C0D0"; font.pixelSize: 12
            anchors.verticalCenter: parent.verticalCenter
        }
    }

    Rectangle {
        visible: countBadge >= 0
        anchors { right: parent.right; rightMargin: 12; verticalCenter: parent.verticalCenter }
        width: Math.max(20, countLabel.implicitWidth + 8); height: 16; radius: 8
        color: "#2A2A3E"
        Text { id: countLabel; anchors.centerIn: parent; text: countBadge; color: "#7070A0"; font.pixelSize: 9 }
    }

    MouseArea {
        id: itemMa; anchors.fill: parent; hoverEnabled: true
        acceptedButtons: Qt.LeftButton | Qt.RightButton
        cursorShape: Qt.PointingHandCursor
        onClicked: (mouse) => {
            if (mouse.button === Qt.RightButton && groupId >= 0) {
                itemContextMenu.popup()
            } else {
                sideItemRoot.itemClicked()
            }
        }
    }
}
