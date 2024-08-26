#include "filemanager.h"
#include <QFile>
#include <QDebug>
#include <QUrl>

FileManager::FileManager(QObject *parent)
    : QObject{parent}
{}

bool FileManager::deleteFile(const QString &filePath)
{
    // Convert the file path to a local file path using QUrl
    QString localFilePath = QUrl::fromUserInput(filePath).toLocalFile();

    // Check if the local file path is valid
    if (localFilePath.isEmpty()) {
        qDebug() << "Invalid file path:" << filePath;
        return false;
    }

    QFile file(localFilePath);
    if (file.remove()) {
        qDebug() << "File deleted successfully:" << localFilePath;
        return true;
    } else {
        qDebug() << "Failed to delete file:" << localFilePath << "Error:" << file.errorString();
        return false;
    }
}
