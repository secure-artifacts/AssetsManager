import QtQuick
import QtQuick.Controls

Dialog {
    id: dlg
    property alias placeholder: inputField.placeholderText
    signal inputAccepted(string text)

    modal: true; title: "新建"
    anchors.centerIn: Overlay.overlay
    width: 320

    background: Rectangle { color: "#1C1C28"; radius: 12; border.color: "#2A2A3C"; border.width: 1 }
    header: Item {}

    contentItem: Column {
        spacing: 16; padding: 20
        Text { text: dlg.title; color: "#E4E4EA"; font.pixelSize: 15; font.weight: Font.Medium }
        TextField {
            id: inputField; width: 280
            color: "#E4E4EA"; placeholderTextColor: "#5A5A70"; font.pixelSize: 13
            background: Rectangle { color: "#252535"; radius: 8; border.color: "#3A3A50"; border.width: 1 }
            onAccepted: { dlg.inputAccepted(text); dlg.close(); text = "" }
        }
        Row {
            spacing: 8; anchors.right: parent.right
            Button {
                text: "取消"
                contentItem: Text { text: parent.text; color: "#8A8A9A"; font.pixelSize: 12 }
                background: Rectangle { color: "transparent" }
                onClicked: dlg.close()
            }
            Button {
                text: "创建"
                contentItem: Text { text: parent.text; color: "white"; font.pixelSize: 12; font.weight: Font.Medium }
                background: Rectangle { color: "#7B68EE"; radius: 8 }
                onClicked: { dlg.inputAccepted(inputField.text); dlg.close(); inputField.text = "" }
            }
        }
    }
}
