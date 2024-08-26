import QtQuick 2.15
import QtQuick.Controls 2.15
import Qt.labs.platform 1.1

Window {
    width: screen.width * 0.7
    height: screen.height * 0.7
    visible: true
    title: qsTr("Recorder")

    Player {
        id: playit
    }
    Rectangle {
        id: titleBox
        width: parent.width
        height: parent.height * 0.1
        anchors.top: parent.top

        Text {
            id: title
            text: qsTr("Recorder")
            anchors.centerIn: parent
            font.family: "Space Grotesk,sans-serif"
            font.pointSize: 20
            font.bold: true
            color: "blue"
        }
    }

    Rectangle {
        id: mainBox
        width: parent.width
        height: parent.height * 0.9
        color: "transparent"
        anchors.top: titleBox.bottom

        Image {
            id: img1
            source: "file:///E:/workspace/Recorder/Images/dark1.5a4726e8.svg"
            anchors.left: parent.left
        }

        Image {
            id: img2
            source: "file:///E:/workspace/Recorder/Images/dark3.cab45a05.svg"
            anchors.right: parent.right
            anchors.top: parent.top
            anchors.topMargin: parent.height * 0.2
        }

        Rectangle {
            id: sidebarTriggerArea
            width: parent.width * 0.1
            height: parent.height
            anchors.right: parent.right
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    sidebar.visible = true
                    sidebar.hideTimer.stop()
                }
                onExited: {
                    sidebar.hideTimer.start()
                }
            }
        }

        Sidebar {
            id: sidebar
            visible: false
            anchors.right: parent.right
            folderPath: "file:///E:/Movies"

            onFileSelected: playit.playMedia(filePath)
            Loader {
                id: contentLoader1
                source: "Player.qml"
            }
            // MouseArea {
            //     id: sidebarMouseArea
            //     anchors.fill: parent
            //     hoverEnabled: true
            //     onExited: {
            //         if (!sidebarTriggerArea.containsMouse) {
            //             sidebar.visible = false
            //         }
            //     }
            // }
        }

        Rectangle {
            id: recordingBox
            height: parent.height
            anchors {
                left: parent.left
                right: parent.right
                leftMargin: img1.width
                rightMargin: img2.width
            }

            Loader {
                id: contentLoader
                anchors.fill: parent
                source: audio.checked ? "Audio.qml" : "Video.qml"
            }
        }

        Item {
            id: radioButtonGroup
            property alias checkedButton: group.checkedButton
            width: parent.width * 0.3
            height: parent.height * 0.2
            anchors {
                left: parent.left
                bottom: parent.bottom
                leftMargin: 10
                bottomMargin: 10
            }

            Column {
                spacing: 10

                Text {
                    text: "Select Type"
                    font.bold: true
                }

                ButtonGroup {
                    id: group
                }

                RadioButton {
                    id: audio
                    text: "Audio"
                    checked: true
                    ButtonGroup.group: group
                }

                RadioButton {
                    id: video
                    text: "Video"
                    ButtonGroup.group: group
                }
            }
        }
    }
}
