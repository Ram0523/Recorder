#ifndef AUDIORECORDER_H
#define AUDIORECORDER_H

#include <QObject>
#include <QMediaRecorder>
#include <QMediaCaptureSession>
#include <QAudioInput>
#include <QUrl>

class audiorecorder : public QObject
{
    Q_OBJECT

public:
    explicit audiorecorder(QObject *parent = nullptr);

public slots:
    Q_INVOKABLE void startRecording();
    Q_INVOKABLE void stopRecording();
    Q_INVOKABLE void setOutputLocation(const QString &path);

signals:
    void recordingStarted();
    void recordingStopped();
    void recordingError(const QString &error);

private:
    QMediaRecorder *mediaRecorder;
    QMediaCaptureSession *captureSession;
    QAudioInput *audioInput;
};

#endif // AUDIORECORDER_H
