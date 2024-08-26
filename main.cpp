#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "filemanager.h"

#include <QIODevice>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);
qmlRegisterType<FileManager>("FileManager", 1, 0, "FileManager");

    QQmlApplicationEngine engine;

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("Recorder", "Main");

    return app.exec();
}
