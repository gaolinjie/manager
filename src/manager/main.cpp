#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>
#include <iostream>
#include <QtSql>
#include <QDebug>
#include "imagemanager.h"

int main(int argc, char *argv[])
{ 
    QApplication::setGraphicsSystem("raster");
    QApplication a(argc, argv);

    QTextCodec::setCodecForTr(QTextCodec::codecForLocale());

    QString privatePathQt(QApplication::applicationDirPath());
    QString path(privatePathQt);
    path = QDir::toNativeSeparators(path);

    QDeclarativeView view;
    view.engine()->setOfflineStoragePath(path);
    QObject::connect((QObject*)view.engine(), SIGNAL(quit()), &a, SLOT(quit()));

    view.setSource(QUrl("qrc:/qml/main.qml"));
    view.show();

    ImageManager imageManager;
    view.rootContext()->setContextProperty("imageManager", &imageManager);

    QString md5;
    QString dbname="DemoDB";
    QByteArray ba;
    ba = QCryptographicHash::hash (dbname.toAscii(), QCryptographicHash::Md5);
    md5.append(ba.toHex());
    md5.append(".sqlite");

    path.append(QDir::separator()).append("Databases");
    path.append(QDir::separator()).append(md5);
    QSqlDatabase db = QSqlDatabase::addDatabase("QSQLITE");
    db.setDatabaseName(path);
    if (!db.open()) {
        std::cerr << "Cannot open database" << std::endl;
        return 1;
    }

    return a.exec();
}
