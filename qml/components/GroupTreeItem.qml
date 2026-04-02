import QtQuick
import QtQuick.Layouts

Column {
    id: tcol
    property var nodeData
    property int depth: 0
    width: parent ? parent.width : root.width
    property bool expanded: true

    SideItem {
        groupId: tcol.nodeData ? tcol.nodeData.id : -1
        icon: (tcol.nodeData && tcol.nodeData.children && tcol.nodeData.children.length > 0) ? (tcol.expanded ? "▾" : "▸") : ""
        label: tcol.nodeData ? tcol.nodeData.name : ""
        countBadge: tcol.nodeData ? tcol.nodeData.asset_count : -1
        indentLevel: tcol.depth
        onItemClicked: {
            libraryModel.setFileTypeFilter("")
            libraryModel.setGroupFilter(tcol.nodeData.id)
        }
        onExpandClicked: tcol.expanded = !tcol.expanded
    }

    Column {
        width: parent.width
        visible: tcol.expanded && tcol.nodeData && tcol.nodeData.children && tcol.nodeData.children.length > 0
        Repeater {
            model: tcol.nodeData ? tcol.nodeData.children : null
            delegate: Loader {
                width: parent.width
                source: "GroupTreeItem.qml"
                onLoaded: {
                    item.nodeData = modelData
                    item.depth = tcol.depth + 1
                }
            }
        }
    }
}
