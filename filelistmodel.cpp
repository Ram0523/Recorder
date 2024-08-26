#include "filelistmodel.h"

FileListModel::FileListModel(QObject *parent)
    : QAbstractListModel(parent)
{}

int FileListModel::rowCount(const QModelIndex &parent) const
{
    if (parent.isValid())
        return 0;
    return m_files.count();
}

QVariant FileListModel::data(const QModelIndex &index, int role) const
{
    if (!index.isValid())
        return QVariant();

    if (role == Qt::DisplayRole)
        return m_files.at(index.row());

    return QVariant();
}

QHash<int, QByteArray> FileListModel::roleNames() const
{
    QHash<int, QByteArray> roles;
    roles[Qt::DisplayRole] = "fileName";
    return roles;
}

QString FileListModel::folder() const
{
    return m_dir.absolutePath();
}

void FileListModel::setFolder(const QString &folder)
{
    if (m_dir.absolutePath() != folder) {
        m_dir.setPath(folder);
        updateFileList();
        emit folderChanged();
    }
}

void FileListModel::updateFileList()
{
    beginResetModel();
    m_files = m_dir.entryList(QStringList() << "*.mp3" << "*.wav" << "*.mp4" << "*.avi" << "*.mov" << "*.mkv", QDir::Files);
    endResetModel();
}
