import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Window {
    width: screen.width * 0.7
    height: screen.height * 0.7
    visible: true
    title: qsTr("Recorder")

    // Store the file path temporarily until the loader is ready
    property string pendingFilePath: ""

    // In your main QML file
    function playMedia(filePath) {
        console.log("playMedia called with:", filePath)
        if (contentLoader1.item && contentLoader1.item.player) {
            contentLoader1.item.player.source = filePath
            contentLoader1.item.player.play()
        } else {
            console.warn("Unable to play media: player not found")
        }
    }

    function handleFileSelected(filePath) {
        console.log("File selected:", filePath)
        if (contentLoader1.status === Loader.Ready && contentLoader1.item
                && contentLoader1.item.playMedia) {
            contentLoader1.item.playMedia(filePath)
        } else {
            console.warn("Content loader is not ready or playMedia not available. Storing file path.")
            pendingFilePath = filePath
        }
    }

    Loader {
        id: contentLoader1
        anchors.fill: recordingBox
        source: "player.qml"
        asynchronous: true

        onLoaded: {
            console.log("Content loader loaded")
            console.log("contentLoader1.item:", contentLoader1.item)
            console.log("contentLoader1.item.playMedia:",
                        contentLoader1.item.playMedia)
            if (pendingFilePath !== "") {
                contentLoader1.item.playMedia(pendingFilePath)
                pendingFilePath = ""
            }
        }
    }

    Timer {
        id: checkLoaderTimer
        interval: 100
        repeat: true
        running: pendingFilePath !== ""
        onTriggered: {
            if (contentLoader1.status === Loader.Ready) {
                playPendingMedia()
                stop()
            }
        }
    }

    Rectangle {
        id: titleBox
        width: parent.width
        height: parent.height * 0.1
        anchors {
            top: parent.top
        }
        Text {
            id: title
            text: qsTr("Recorder")
            anchors.centerIn: titleBox
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
        anchors {
            top: titleBox.bottom
        }

        Image {
            id: img1
            source: "file:///C:/Users/Ram Mourya/Downloads/dark1.5a4726e8.svg"
            anchors.left: mainBox.left
        }

        Image {
            id: img2
            source: "file:///C:/Users/Ram Mourya/Downloads/dark3.cab45a05.svg"
            anchors.right: mainBox.right
            anchors.top: mainBox.top
            anchors.topMargin: mainBox.height * 0.2
        }
        Rectangle {
            id: sidebarTriggerArea
            width: mainBox.width * 0.1 // Adjust this value to change the trigger area width
            height: mainBox.height
            anchors.right: mainBox.right
            color: "transparent"

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: sidebar.visible = true
                // onExited: {
                //     if (!sidebarMouseArea.containsMouse) {
                //         sidebar.visible = false
                //     }
                // }
            }
        }

        Sidebar {
            id: sidebar
            visible: false // Set this to true for testing
            anchors.right: mainBox.right
            folderPath: "file:///E:/Movies"
            onFileSelected: function (filePath) {
                // Change this line
                handleFileSelected(filePath)
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

        // Loader {
        //     id: contentLoader1
        //     anchors.fill: recordingBox
        //     source: "player.qml"
        //     asynchronous: true // Add this line to load asynchronously
        //     onLoaded: {
        //         if (pendingFilePath !== "" && item && item.playMedia) {
        //             item.playMedia(pendingFilePath)
        //             pendingFilePath = ""
        //         }
        //     }
        // }
        Rectangle {
            id: recordingBox
            // width: parent.width - img1.implicitWidth - img2.implicitWidth
            height: mainBox.height // Add height here
            anchors {
                left: mainBox.left
                right: mainBox.right
                leftMargin: img1.implicitWidth
                rightMargin: img2.implicitWidth
            }
            // color: "red"
            Loader {
                id: contentLoader
                anchors.fill: parent
                source: audio.checked ? "Audio.qml" : "Video.qml"
            }
        }

        Item {
            id: radioButtonGroup
            property alias checkedButton: group.checkedButton
            width: mainBox.width * 0.3
            height: mainBox.height * 0.2
            anchors {
                left: mainBox.left
                bottom: mainBox.bottom
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
