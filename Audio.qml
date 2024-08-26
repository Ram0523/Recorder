import QtQuick
import QtQuick.Controls
import QtMultimedia
import Qt.labs.platform

Rectangle {
    id: audioRec
    width: parent.width
    height: parent.height

    Rectangle {
        id: imageBox
        width: audioRec.width
        height: audioRec.height * 0.7
        anchors.top: parent.top

        Image {
            id: imgW
            source: "file:///C:/Users/Ram Mourya/Downloads/Sound-Wave-Transparent.png"
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
        }

        // Blinking indicator
        Rectangle {
            id: recordingIndicator
            width: 20
            height: 20
            color: "red"
            radius: 10 // Make it circular
            anchors {
                top: parent.top
                right: parent.right
                topMargin: 10
                rightMargin: 10
            }
            visible: false
            Timer {
                id: blinkTimer
                interval: 500 // Blinks every 500ms
                running: false // Not running by default
                repeat: true
                onTriggered: {
                    recordingIndicator.visible = !recordingIndicator.visible
                }
            }
        }
    }

    Rectangle {
        id: buttonBox
        width: audioRec.width
        height: audioRec.height * 0.3
        anchors.top: imageBox.bottom

        Button {
            id: startA
            text: "Start Recording"
            width: buttonBox.width * 0.4
            height: buttonBox.height * 0.6
            anchors {
                left: buttonBox.left
                leftMargin: buttonBox.width * 0.05
                verticalCenter: buttonBox.verticalCenter
            }
            font.bold: true
            font.pixelSize: 16
            background: Rectangle {
                color: "#90EE90" // Light green shade
                radius: 10
            }
            onClicked: {
                if (mediaRecorder.recorderState === MediaRecorder.StoppedState) {
                    console.log("Starting recording...")
                    mediaRecorder.record()
                    startA.text = "Recording..."
                    startA.enabled = false
                    stopA.text = "Stop Recording"
                    stopA.enabled = true
                    recordingIndicator.visible = true
                    blinkTimer.start()
                }
            }
        }

        Button {
            id: stopA
            text: "Stop"
            width: buttonBox.width * 0.4
            height: buttonBox.height * 0.6
            anchors {
                right: buttonBox.right
                rightMargin: buttonBox.width * 0.05
                verticalCenter: buttonBox.verticalCenter
            }
            font.bold: true
            font.pixelSize: 16
            background: Rectangle {
                color: "#FF7F7F" // Light red shade
                radius: 10
            }
            enabled: false
            onClicked: {
                if (mediaRecorder.recorderState === MediaRecorder.RecordingState) {
                    console.log("Stopping recording...")
                    mediaRecorder.stop()
                    startA.text = "Start Recording"
                    startA.enabled = true
                    stopA.text = "Stop"
                    stopA.enabled = false
                    recordingIndicator.visible = false
                    blinkTimer.stop()
                }
            }
        }
    }

    CaptureSession {
        id: captureSession

        audioInput: AudioInput {
            id: audioInput
        }

        recorder: MediaRecorder {
            id: mediaRecorder
            outputLocation: "file:///E:/workspace/Recorder/Recordings"
        }
    }
}
