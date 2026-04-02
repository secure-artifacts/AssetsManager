import QtQuick
import QtQuick.Controls

Rectangle {
    property alias title: titleLabel.text
    property string actionIcon: ""
    signal actionClicked()

    width: parent ? parent.width : 200; height: 36
    color: "transparent"

    Text {
        id: titleLabel
        anchors { left: parent.left; leftMargin: 16; verticalCenter: parent.verticalCenter }
        color: "#5A5A72"; font.pixelSize: 10; font.weight: Font.Medium
        font.letterSpacing: 1.2
    }
    Text {
        anchors { right: parent.right; rightMargin: 16; verticalCenter: parent.verticalCenter }
        text: actionIcon; color: "#5A5A72"; font.pixelSize: 14
        visible: actionIcon !== ""
        MouseArea {
            anchors.fill: parent; cursorShape: Qt.PointingHandCursor
            onClicked: parent.parent.actionClicked()
        }
    }
}
