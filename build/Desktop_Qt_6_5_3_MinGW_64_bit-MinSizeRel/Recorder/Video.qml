import QtQuick
import QtQuick.Controls
import QtMultimedia

Item {

    CaptureSession {
        id: playMusic
        audioInput: AudioInput {
            volume: slider.value
        }
        recorder: MediaRecorder {
            id: recorder
        }
    }
    Slider {
        id: slider
        from: 0.
        to: 1.
    }
}
