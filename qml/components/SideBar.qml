import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: root
    color: "#0F0F16"

    // Reload when groups/tags change
    Connections {
        target: tagController
        function onGroupsChanged() { groupRepeater.model = tagController.getGroupTree() }
        function onTagsChanged()   { tagRepeater.model   = tagController.getAllTags()   }
    }

    Flickable {
        anchors.fill: parent
        contentHeight: sideContent.implicitHeight
        clip: true

        Column {
            id: sideContent
            width: parent.width
            spacing: 0

            // ── Section: Library ──────────────────────────────────────
            SideSection { title: "库" }

            SideItem {
                icon: "◈"; label: "全部素材"
                onItemClicked: {
                    libraryModel.setGroupFilter(-1)
                    libraryModel.setFileTypeFilter("")
                }
            }
            SideItem {
                icon: "▣"; label: "图片"
                onItemClicked: {
                    libraryModel.setGroupFilter(-1)
                    libraryModel.setFileTypeFilter("image")
                }
            }
            SideItem {
                icon: "▶"; label: "视频"
                onItemClicked: {
                    libraryModel.setGroupFilter(-1)
                    libraryModel.setFileTypeFilter("video")
                }
            }
            SideItem {
                icon: "♪"; label: "音频"
                onItemClicked: {
                    libraryModel.setGroupFilter(-1)
                    libraryModel.setFileTypeFilter("audio")
                }
            }

            // ── Section: Groups ───────────────────────────────────────
            SideSection {
                title: "分组"
                actionIcon: "+"
                onActionClicked: newGroupDialog.open()
            }

            Repeater {
                id: groupRepeater
                model: tagController.getGroupTree()
                delegate: GroupTreeItem {
                    nodeData: modelData
                    depth: 0
                }
            }

            // ── Section: Tags ─────────────────────────────────────────
            SideSection {
                title: "标签"
                actionIcon: "+"
                onActionClicked: newTagDialog.open()
            }

            Repeater {
                id: tagRepeater
                model: tagController.getAllTags()
                delegate: SideItem {
                    icon: "●"; iconColor: modelData.color
                    label: modelData.name
                    onItemClicked: {
                        // TODO: multi-tag filter
                    }
                }
            }

            Item { height: 24 }
        }
    }

    // ── Dialogs ───────────────────────────────────────────────────────
    SimpleInputDialog {
        id: newGroupDialog
        title: "新建分组"
        placeholder: "分组名称…"
        onInputAccepted: (text) => tagController.createGroup(text, -1, "#7B68EE")
    }

    SimpleInputDialog {
        id: newTagDialog
        title: "新建标签"
        placeholder: "标签名称…"
        onInputAccepted: (text) => tagController.createTag(text, "#7B68EE", "General")
    }

    // ── Inline components ────────────────────────────────────────────

}
