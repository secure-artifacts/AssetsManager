import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {
    id: root
    visible: previewController.visible

    property var asset: previewController.currentAsset

    // ── Media Player ───────────────────────────────────────────────────
    MediaPlayer {
        id: player
        autoPlay: true
        audioOutput: AudioOutput {}
        videoOutput: videoOutput
        
        // Robust URL construction
        source: {
            if (!asset || asset.file_type === "image") return ""
            let p = asset.file_path
            if (p.startsWith("/")) return "file://" + p
            return "file:///" + p
        }

        onPlaybackStateChanged: {
            // Auto-loop video
            if (playbackState === MediaPlayer.StoppedState && asset && asset.file_type === "video" && root.visible)
                player.play()
        }

        onErrorOccurred: (error, errorString) => {
            console.log("MediaPlayer Error:", error, errorString)
        }
    }

    // ── Dim background ─────────────────────────────────────────────────
    Rectangle {
        anchors.fill: parent
        color: Qt.rgba(0, 0, 0, 0.88)
        opacity: root.visible ? 1 : 0
        Behavior on opacity { NumberAnimation { duration: 200 } }

        MouseArea {
            anchors.fill: parent
            onClicked: previewController.closePreview()
        }
    }

    // ── Media container ────────────────────────────────────────────────
    Item {
        id: mediaContainer
        anchors {
            top: parent.top; bottom: infoBar.top
            left: parent.left; right: parent.right
            margins: 60
        }

        scale: root.visible ? 1 : 0.85
        opacity: root.visible ? 1 : 0
        Behavior on scale   { NumberAnimation { duration: 220; easing.type: Easing.OutCubic } }
        Behavior on opacity { NumberAnimation { duration: 200 } }

        // Image preview
        Image {
            id: previewImage
            anchors.fill: parent
            source: asset && asset.file_type === "image" ? (asset.file_path.startsWith("/") ? "file://" : "file:///") + asset.file_path : ""
            fillMode: Image.PreserveAspectFit
            asynchronous: true
            smooth: true
            visible: asset && asset.file_type === "image"
        }

        // Video preview
        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            visible: asset && asset.file_type === "video"
        }

        // Video control / Play status
        MouseArea {
            anchors.fill: videoOutput
            visible: videoOutput.visible
            onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
        }

        // Audio preview
        Column {
            anchors.centerIn: parent
            spacing: 24
            visible: asset && asset.file_type === "audio"
            
            // Audio visualizer placeholder
            Rectangle {
                width: 120; height: 120; radius: 60
                color: "#1E1E28"
                anchors.horizontalCenter: parent.horizontalCenter
                Text {
                    anchors.centerIn: parent
                    text: player.playbackState === MediaPlayer.PlayingState ? "♪" : "⏸"
                    color: "#7B68EE"; font.pixelSize: 48
                }
                
                // Pulsing animation for audio
                SequentialAnimation on scale {
                    running: player.playbackState === MediaPlayer.PlayingState && asset && asset.file_type === "audio"
                    loops: Animation.Infinite
                    NumberAnimation { from: 1.0; to: 1.1; duration: 500; easing.type: Easing.InOutQuad }
                    NumberAnimation { from: 1.1; to: 1.0; duration: 500; easing.type: Easing.InOutQuad }
                }
            }

            Text {
                text: asset ? asset.file_name : ""
                color: "#E4E4EA"; font.pixelSize: 18; font.weight: Font.Medium
                anchors.horizontalCenter: parent.horizontalCenter
            }
            
            // Simple play/pause for audio
            Button {
                anchors.horizontalCenter: parent.horizontalCenter
                text: player.playbackState === MediaPlayer.PlayingState ? "暂停" : "播放"
                onClicked: player.playbackState === MediaPlayer.PlayingState ? player.pause() : player.play()
            }
        }
    }

    // ── Navigation arrows ───────────────────────────────────────────────
    NavArrow {
        anchors { left: parent.left; leftMargin: 16; verticalCenter: mediaContainer.verticalCenter }
        text: "‹"; onClicked: { player.stop(); previewController.prevAsset() }
    }
    NavArrow {
        anchors { right: parent.right; rightMargin: 16; verticalCenter: mediaContainer.verticalCenter }
        text: "›"; onClicked: { player.stop(); previewController.nextAsset() }
    }

    // ── Info bar ────────────────────────────────────────────────────────
    Rectangle {
        id: infoBar
        anchors { bottom: parent.bottom; left: parent.left; right: parent.right }
        height: 56; color: Qt.rgba(0.05, 0.05, 0.1, 0.95)

        Row {
            anchors { left: parent.left; leftMargin: 24; verticalCenter: parent.verticalCenter }
            spacing: 24

            Column {
                visible: !!asset
                Text {
                    text: asset ? asset.file_name : ""
                    color: "#E4E4EA"; font.pixelSize: 13; font.weight: Font.Medium
                }
                Text {
                    text: asset
                        ? (asset.file_type.toUpperCase()
                           + (asset.width ? "  " + asset.width + "×" + asset.height : "")
                           + (asset.size_bytes ? "  " + (asset.size_bytes / 1048576).toFixed(1) + " MB" : ""))
                        : ""
                    color: "#6B6B80"; font.pixelSize: 11
                }
            }
        }

        // Close button
        Rectangle {
            anchors { right: parent.right; rightMargin: 20; verticalCenter: parent.verticalCenter }
            width: 32; height: 32; radius: 16; color: closeBtnMa.containsMouse ? "#2A2A3E" : "transparent"
            Text { anchors.centerIn: parent; text: "✕"; color: "#8A8A9A"; font.pixelSize: 14 }
            MouseArea {
                id: closeBtnMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
                onClicked: previewController.closePreview()
            }
        }
    }

    // Lifecycle management
    onVisibleChanged: {
        if (!visible) player.stop()
    }
    
    onAssetChanged: {
        player.stop()
        if (visible && asset && (asset.file_type === "video" || asset.file_type === "audio")) {
            player.play()
        }
    }

    // ── NavArrow component ──────────────────────────────────────────────
    component NavArrow: Rectangle {
        property alias text: arrowLabel.text
        signal clicked()

        width: 44; height: 44; radius: 22; color: navMa.containsMouse ? "#2A2A3E" : Qt.rgba(0,0,0,0.4)
        Behavior on color { ColorAnimation { duration: 120 } }

        Text { id: arrowLabel; anchors.centerIn: parent; color: "white"; font.pixelSize: 28 }
        MouseArea {
            id: navMa; anchors.fill: parent; hoverEnabled: true; cursorShape: Qt.PointingHandCursor
            onClicked: parent.clicked()
        }
    }
}
