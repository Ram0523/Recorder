import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15
import QtQuick.Dialogs
import QtQuick.Layouts 1.15
import FileManager 1.0

// Import our custom C++ class
Rectangle {
    id: root
    width: parent.width * 0.2
    height: parent.height
    color: "#f0f0f0"
    property string folderPath: "file:///E:/Movies"
    signal fileSelected(string filePath)
    property alias sidebarMouseArea: sidebarMouseArea
    property alias hideTimer: hideTimer

    FileManager {
        id: fileManager
    }

    // Component.onCompleted: {
    //     console.log("Sidebar component loaded")
    // }
    Timer {
        id: hideTimer
        interval: 500
        repeat: false
        onTriggered: {
            sidebar.visible = false
        }
    }

    MouseArea {
        id: sidebarMouseArea
        anchors.fill: parent
        hoverEnabled: true
        onEntered: hideTimer.stop()
        onExited: {
            hideTimer.start()
        }
    }

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: fileList
            width: scrollView.width
            model: FolderListModel {
                id: folderModel
                folder: root.folderPath
                nameFilters: ["*.mp3", "*.wav", "*.mp4", "*.avi", "*.mov", "*.mkv", "*.m4a"]
                showDirs: false
            }
            delegate: ItemDelegate {
                width: fileList.width
                height: 40

                RowLayout {
                    anchors.fill: parent
                    anchors.margins: 5
                    spacing: 5

                    Label {
                        Layout.fillWidth: true
                        text: model.fileName
                        elide: Text.ElideRight
                    }

                    Button {
                        Layout.preferredWidth: 60
                        text: "Play"
                        onClicked: {
                            root.fileSelected(model.filePath)
                            console.log("Playing: " + model.fileName)
                        }
                    }

                    Button {
                        Layout.preferredWidth: 60
                        text: "Delete"
                        onClicked: {
                            deleteFileDialog.filePath = model.filePath
                            deleteFileDialog.open()
                        }
                    }
                }

                background: Rectangle {
                    color: "lightgray"
                    radius: 5
                }
            }
        }
    }

    Dialog {
        id: deleteFileDialog
        title: "Delete File"
        standardButtons: Dialog.Ok | Dialog.Cancel
        property string filePath: ""

        onOpened: {
            console.log("Delete dialog opened for file: " + filePath)
        }

        contentItem: Label {
            text: "Are you sure you want to delete this file?\n" + deleteFileDialog.filePath
        }

        onAccepted: {
            console.log("Attempting to delete: " + filePath)
            if (fileManager.deleteFile(filePath)) {
                console.log("File deleted:", filePath)
                folderModel.refresh()
            } else {
                console.error("Failed to delete file:", filePath)
            }
        }

        onRejected: {
            console.log("Deletion cancelled")
        }
    }
}
