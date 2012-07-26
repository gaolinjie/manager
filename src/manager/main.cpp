#include <QtGui/QApplication>
#include <QtDeclarative/QDeclarativeView>
#include <QtDeclarative/QDeclarativeEngine>
#include <QtDeclarative/QDeclarativeContext>
//#include <iostream>
#include <QtSql>
#include <QDate>
#include <QtNetwork>
#include <QDebug>

#include "imagemanager.h"
#include "client.h"
#include "printer.h"
#include "server.h"
#include "ordermanager.h"
#include "digitalclock.h"
#include "ordersave.h"
#include "syncmanager.h"

int main(int argc, char *argv[])
{ 
    QApplication::setGraphicsSystem("raster");
    QApplication a(argc, argv);

    QTextCodec::setCodecForTr(QTextCodec::codecForLocale());

    QString privatePathQt(QApplication::applicationDirPath());
    QString path(privatePathQt);
    path = QDir::toNativeSeparators(path);

    Server server;
    if (!server.listen(QHostAddress::Any, 6178)) {
        qDebug() << "Failed to bind to port";
        return 1;
    }



    QDeclarativeView view;
    view.engine()->setOfflineStoragePath(path);
    QObject::connect((QObject*)view.engine(), SIGNAL(quit()), &a, SLOT(quit()));

    SyncManager syncManager;
    view.rootContext()->setContextProperty("syncManager", &syncManager);

    view.setSource(QUrl("qrc:/qml/main.qml"));
    view.setBackgroundRole(QPalette::Dark);
    view.show();

    ImageManager imageManager;
    view.rootContext()->setContextProperty("imageManager", &imageManager);

    OrderManager orderManager;
    OrderSave ordersave;
    DigitalClock systemClock;
    Printer  printOrder;

    view.rootContext()->setContextProperty("server", &server);
    view.rootContext()->setContextProperty("orderManager", &orderManager);
    view.rootContext()->setContextProperty("ordersave", &ordersave);
    view.rootContext()->setContextProperty("printOrder", &printOrder);
    view.rootContext()->setContextProperty("systemClock", &systemClock);


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
        qDebug() << "Cannot open database";
        return 1;
    }

    Client client;
    view.rootContext()->setContextProperty("client", &client);
    QObject::connect(&orderManager, SIGNAL(pay(quint32)), &client, SLOT(sendPaiedOrder(quint32)));
    QObject::connect(&server, SIGNAL(registered(quint32)), &client, SLOT(sendDeviceNO(quint32)));

    return a.exec();
}
