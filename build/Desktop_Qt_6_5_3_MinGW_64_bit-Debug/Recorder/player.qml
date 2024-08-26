import QtQuick
import QtQuick.Controls
import QtMultimedia
import Qt.labs.platform

Rectangle {
    id: playerRec
    width: parent.width
    height: parent.height
    // Expose the playMedia function
    function playMedia(filePath) {
        console.log("playMedia in player.qml called with:", filePath)
        // player.source = filePath
        path1 = filePath
        player.play()
    }
    property alias player: player // Expose the player objec
    property string path1: ""

    Rectangle {
        id: mediaBox
        width: playerRec.width
        height: playerRec.height * 0.7
        anchors.top: parent.top
        color: "black"

        VideoOutput {
            id: videoOutput
            anchors.fill: parent
            visible: player.hasVideo
            onSourceRectChanged: {
                console.log("VideoOutput sourceRect changed:", sourceRect)
            }
            onContentRectChanged: {
                console.log("VideoOutput contentRect changed:", contentRect)
            }
        }

        MediaPlayer {
            id: player
            videoOutput: videoOutput
            audioOutput: AudioOutput {
                volume: 1.0
            }
            source: path1

            onErrorChanged: {
                if (error !== MediaPlayer.NoError) {
                    console.error("MediaPlayer error:", error, errorString)
                }
            }
            onSourceChanged: {
                console.log("MediaPlayer source changed to:", source)
            }
            onPlaybackStateChanged: {
                console.log("MediaPlayer playback state changed to:",
                            playbackState)
            }
            onMediaStatusChanged: {
                console.log("MediaPlayer media status changed to:", mediaStatus)
                if (mediaStatus === MediaPlayer.Loaded) {
                    console.log("Media is fully loaded, playing now.")
                    play()
                }
            }
            onHasVideoChanged: {
                console.log("MediaPlayer hasVideo changed to:", hasVideo)
            }
        }
    }

    Rectangle {
        id: buttonBox
        width: playerRec.width
        height: playerRec.height * 0.3
        anchors.top: mediaBox.bottom

        Button {
            id: playButton
            text: "Play"
            width: buttonBox.width * 0.4
            height: buttonBox.height * 0.6
            anchors {
                left: buttonBox.left
                leftMargin: buttonBox.width * 0.1
                verticalCenter: buttonBox.verticalCenter
            }
            font.bold: true
            font.pixelSize: 16

            contentItem: Text {
                text: playButton.text
                font: playButton.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: "blue"
                radius: 10
            }

            onClicked: player.play()
        }

        Button {
            id: pauseButton
            text: "Pause"
            width: buttonBox.width * 0.4
            height: buttonBox.height * 0.6
            anchors {
                right: buttonBox.right
                rightMargin: buttonBox.width * 0.1
                verticalCenter: buttonBox.verticalCenter
            }
            font.bold: true
            font.pixelSize: 16

            contentItem: Text {
                text: pauseButton.text
                font: pauseButton.font
                color: "white"
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            background: Rectangle {
                color: "blue"
                radius: 10
            }

            onClicked: player.pause()
        }
    }
}
