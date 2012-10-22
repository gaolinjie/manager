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
#include "idmanager.h"
#include "signalmanager.h"

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
    ImageManager imageManager;
    view.rootContext()->setContextProperty("imageManager", &imageManager);

    OrderSave ordersave;
    DigitalClock systemClock;
    Printer  printOrder;
    view.rootContext()->setContextProperty("server", &server);  
    view.rootContext()->setContextProperty("ordersave", &ordersave);
    view.rootContext()->setContextProperty("printOrder", &printOrder);
    view.rootContext()->setContextProperty("systemClock", &systemClock);

    view.setSource(QUrl("qrc:/qml/main.qml"));
    view.setBackgroundRole(QPalette::Dark);
    view.show();

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
    printOrder.printerList(); //��ȡ���п��ô�ӡ����Ϣ�б�

    OrderManager orderManager;
    view.rootContext()->setContextProperty("orderManager", &orderManager);
    Client client;
    view.rootContext()->setContextProperty("client", &client);
    QObject::connect(&orderManager, SIGNAL(pay(QString)), &client, SLOT(sendPaiedOrder(QString)));
    QObject::connect(&server, SIGNAL(registered(quint32)), &client, SLOT(sendDeviceNO(quint32)));
    QObject::connect(&server, SIGNAL(registered(quint32)), &syncManager, SLOT(sendNeedSyncSignal()));

    IDManager idManager;
    SignalManager signalManager;
    view.rootContext()->setContextProperty("idManager", &idManager);
    view.rootContext()->setContextProperty("signalManager", &signalManager);

    return a.exec();
}
