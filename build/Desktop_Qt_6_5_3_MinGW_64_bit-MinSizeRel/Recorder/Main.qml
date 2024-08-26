import QtQuick
import QtQuick.Controls
import Qt.labs.platform

Window {
    width: screen.width * 0.7
    height: screen.height * 0.7
    visible: true
    title: qsTr("Recorder")

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
            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: sidebar.visible = true
                onExited: sidebar.visible = false
            }
        }

        Rectangle {
            id: sidebar
            width: mainBox.width * 0.2
            height: mainBox.height
            color: "gray"
            opacity: 0.3
            visible: false
            anchors.right: mainBox.right
        }

        Rectangle {
            id: recordingBox
            // width: parent.width - img1.implicitWidth - img2.implicitWidth
            height: mainBox.height * 0.8 // Add height here
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

        Rectangle {
            id: controls
            height: mainBox.height * 0.2
            anchors {
                left: mainBox.left
                right: mainBox.right
                top: recordingBox.bottom
                leftMargin: img1.implicitWidth
                rightMargin: img2.implicitWidth
            }
            // color: "blue"
            Button {
                id: startButton
                text: "Start"
                width: controls.width * 0.2
                height: controls.height * 0.5
                anchors {
                    left: controls.left
                    leftMargin: controls.width * 0.2
                    top: controls.top
                    topMargin: controls.height * 0.3
                }
                font.bold: true
                font.pixelSize: 16
                contentItem: Text {
                    text: startButton.text
                    font: startButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "blue"
                    radius: 10
                }
                onClicked: {
                    console.log("Start button clicked")
                    var outputPath = StandardPaths.writableLocation(
                                StandardPaths.DocumentsLocation) + "/audio.mp4"
                    console.log("Output path:", outputPath)
                    audioRecorder.setOutputLocation(outputPath)
                    audioRecorder.startRecording()
                }
            }

            Button {
                id: stopButton
                text: "Stop"
                width: controls.width * 0.2
                height: controls.height * 0.5
                anchors {
                    right: controls.right
                    rightMargin: controls.width * 0.2
                    top: controls.top
                    topMargin: controls.height * 0.3
                }
                font.bold: true
                font.pixelSize: 16
                contentItem: Text {
                    text: stopButton.text
                    font: stopButton.font
                    color: "white"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
                background: Rectangle {
                    color: "blue"
                    radius: 10
                }
                onClicked: {
                    audioRecorder.stopRecording()
                }
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
