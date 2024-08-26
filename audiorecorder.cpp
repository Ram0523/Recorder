#include "audiorecorder.h"
#include <QMediaDevices>
#include <QAudioDevice>
#include <QMediaRecorder>
#include <QDebug>

audiorecorder::audiorecorder(QObject *parent)
    : QObject{parent},
    mediaRecorder(new QMediaRecorder(this)),
    captureSession(new QMediaCaptureSession(this)),
    audioInput(nullptr) // Initialize audioInput to nullptr
{
    // Get the default audio input device
    QAudioDevice defaultAudioDevice = QMediaDevices::defaultAudioInput();
    if (!defaultAudioDevice.isNull()) {
        audioInput = new QAudioInput(defaultAudioDevice, this); // Create QAudioInput with the default device
        captureSession->setAudioInput(audioInput);
        captureSession->setRecorder(mediaRecorder);

        // Set media format (optional: you can change this depending on your requirements)
        // mediaRecorder->setAudioSettings(QAudioEncoderSettings());
        // mediaRecorder->setContainerFormat("mp4"); // Set container format
    } else {
        qWarning() << "No audio input devices available!";
    }
}

void audiorecorder::startRecording()
{
    // Check if mediaRecorder is correctly set up
    if (audioInput && mediaRecorder) {
        mediaRecorder->record();
        emit recordingStarted(); // Emit signal for UI feedback
    } else {
        emit recordingError("Audio input or media recorder not set up properly.");
    }
}

void audiorecorder::stopRecording()
{
    mediaRecorder->stop();
    emit recordingStopped(); // Emit signal for UI feedback
}

void audiorecorder::setOutputLocation(const QString &path)
{
    QUrl url = QUrl::fromLocalFile(path);
    if (url.isValid()) {
        mediaRecorder->setOutputLocation(url);
        qDebug() << "Setting output location to:" << url.toString();
        qDebug() << "Output location after setting:" << mediaRecorder->outputLocation().toString();
    } else {
        qWarning() << "Invalid output location:" << path;
    }
}
