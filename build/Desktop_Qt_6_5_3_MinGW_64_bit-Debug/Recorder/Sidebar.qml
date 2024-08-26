import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.folderlistmodel 2.15

Rectangle {
    id: root
    width: parent.width * 0.2
    height: parent.height
    color: "#f0f0f0"

    property string folderPath: "file:///E:/Movies"

    // property bool loadingComplete: false
    signal fileSelected(string filePath)

    ScrollView {
        id: scrollView
        anchors.fill: parent

        ListView {
            id: fileList
            width: scrollView.width
            model: FolderListModel {
                id: folderModel
                folder: root.folderPath
                nameFilters: ["*.mp3", "*.wav", "*.mp4", "*.avi", "*.mov", "*.mkv"]
                showDirs: false
                // onCountChanged: {
                //     console.log("Model updated, number of files:", count)
                //     if (count > 0) {
                //         loadingComplete = true
                //     }
                // }
            }
            delegate: ItemDelegate {
                width: fileList.width
                height: 40
                text: model.fileName
                background: Rectangle {
                    color: "lightgray"
                    radius: 5
                }
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        // console.log("Selected file:", model.filePath)
                        root.fileSelected(model.filePath)
                    }
                }
            }
        }
    }
}
