import QtQuick
import QtQuick.Controls
import QtMultimedia
import Qt.labs.platform

Window {
    id: playscreen
    width: screen.width * 0.6
    height: screen.height * 0.6
    visible: false
    title: qsTr("Player")

    function playMedia(filePath) {
        console.log("playMedia in player.qml called with:", filePath)
        playscreen.visible = true
        player.source = filePath
        player.play()
    }

    Rectangle {
        id: playerRec
        width: parent.width
        height: parent.height
        color: "black"

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            visible: player.hasVideo
            fillMode: VideoOutput.PreserveAspectFit
        }

        MediaPlayer {
            id: player
            videoOutput: videoOutput
            audioOutput: AudioOutput {
                volume: volumeSlider.value
            }
        }

        Rectangle {
            id: controlsBox
            width: parent.width
            height: parent.height * 0.15
            anchors.bottom: parent.bottom
            color: "#333333"
            opacity: 0.8

            Row {
                id: controlRow
                spacing: controlsBox.width * 0.01 // Spacing between buttons, adjusted dynamically
                // anchors.centerIn: parent
                anchors {
                    left: controlsBox.left
                    right: controlsBox.right
                    leftMargin: controlsBox.width * 0.03
                    rightMargin: controlsBox.width * 0.03
                }

                Button {
                    id: playPauseButton
                    width: controlsBox.width * 0.17 // Adjusted width to balance
                    height: controlsBox.height * 0.8
                    text: player.playbackState === MediaPlayer.PlayingState ? "Pause" : "Play"
                    onClicked: player.playbackState
                               === MediaPlayer.PlayingState ? player.pause(
                                                                  ) : player.play()
                    font.bold: true
                    font.pixelSize: controlsBox.height * 0.3
                    contentItem: Text {
                        text: playPauseButton.text
                        color: "white"
                        font: playPauseButton.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: "blue"
                        radius: 5
                    }
                }

                Button {
                    id: stopButton
                    width: controlsBox.width * 0.17 // Same width as playPauseButton
                    height: controlsBox.height * 0.8
                    text: "Stop"
                    onClicked: player.stop()
                    font.bold: true
                    font.pixelSize: controlsBox.height * 0.3
                    contentItem: Text {
                        text: stopButton.text
                        color: "white"
                        font: stopButton.font
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }
                    background: Rectangle {
                        color: "red"
                        radius: 5
                    }
                }

                Slider {
                    id: volumeSlider
                    width: controlsBox.width * 0.17 // Adjusted width to balance
                    height: controlsBox.height * 0.7
                    anchors.margins: controlsBox.height * 0.1
                    from: 0
                    to: 1
                    value: 0.6 // Default volume (60%)
                    onValueChanged: player.audioOutput.volume = value
                }

                Slider {
                    id: playbackRateSlider
                    width: controlsBox.width * 0.17 // Adjusted width to balance
                    height: controlsBox.height * 0.7
                    anchors.margins: controlsBox.height * 0.1
                    from: 0.5
                    to: 2.0
                    value: 1.0 // Default playback rate (normal speed)
                    stepSize: 0.1
                    onValueChanged: player.playbackRate = value
                }

                Slider {
                    id: progressSlider
                    width: controlsBox.width * 0.24 // Adjusted width to balance
                    height: controlsBox.height * 0.7
                    anchors.margins: controlsBox.height * 0.1
                    from: 0
                    to: player.duration
                    value: player.position
                    onMoved: player.setPosition(value)
                }
            }
        }
    }
}
