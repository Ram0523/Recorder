#ifndef FILELISTMODEL_H
#define FILELISTMODEL_H

#include <QAbstractListModel>
#include <QDir>
#include <QVariant>
#include <QObject>

class FileListModel :  public QAbstractListModel
{
    Q_OBJECT
    Q_PROPERTY(QString folder READ folder WRITE setFolder NOTIFY folderChanged)
public:
    explicit FileListModel(QObject *parent = nullptr);

    int rowCount(const QModelIndex &parent = QModelIndex()) const override;
    QVariant data(const QModelIndex &index, int role = Qt::DisplayRole) const override;
    QHash<int, QByteArray> roleNames() const override;

    QString folder() const;
    void setFolder(const QString &folder);

signals:
    void folderChanged();

private:
    void updateFileList();

    QDir m_dir;
    QStringList m_files;
};

#endif // FILELISTMODEL_H
