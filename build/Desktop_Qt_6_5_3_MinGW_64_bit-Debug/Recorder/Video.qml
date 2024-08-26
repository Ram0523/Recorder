import QtQuick
import QtQuick.Controls
import QtMultimedia
import Qt.labs.platform

Rectangle {
    id: videoRec
    width: parent.width
    height: parent.height

    Rectangle {
        id: videoBox
        width: videoRec.width
        height: videoRec.height * 0.7
        anchors.top: parent.top
        color: "black"

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
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

    CaptureSession {
        id: captureSession
        camera: Camera {
            id: camera
            onErrorOccurred: {
                console.error("Camera error: " + errorString)
            }
        }
        videoOutput: videoOutput
        recorder: MediaRecorder {
            id: mediaRecorder
            onErrorOccurred: {
                console.error("Recording error: " + error)
            }
            outputLocation: "file:///C:/Users/Ram Mourya/Desktop/workspace/Recorder/Recordings"
        }
        audioInput: AudioInput {}
    }

    Rectangle {
        id: buttonBox
        width: videoRec.width
        height: videoRec.height * 0.3
        anchors.top: videoBox.bottom

        Button {
            id: startButton
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
                    startButton.text = "Recording..."
                    startButton.enabled = false
                    stopButton.text = "Stop Recording"
                    stopButton.enabled = true
                    recordingIndicator.visible = true
                    blinkTimer.start()
                }
            }
        }

        Button {
            id: stopButton
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
                    startButton.text = "Start Recording"
                    startButton.enabled = true
                    stopButton.text = "Stop"
                    stopButton.enabled = false
                    recordingIndicator.visible = false
                    blinkTimer.stop()
                }
            }
        }
    }

    Component.onCompleted: {
        captureSession.camera.start()
    }
}
