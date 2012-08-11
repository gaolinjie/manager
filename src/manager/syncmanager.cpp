#include "syncmanager.h"
#include "client.h"
#include <QtSql>

SyncManager::SyncManager(QObject *parent) :
    QObject(parent)
{
}

void SyncManager::syncMenu()
{
    qDebug() << "sssssssssssssssssssssssssssssssssssss";
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER, synced INTEGER)");
    query.exec("SELECT * FROM deviceDB WHERE synced = 0");

    QString ip = "";
    while (query.next())
    {
        qDebug() << "ddddddddddddddddddddd";
        ip = query.value(1).toString();
        Client *socket = new Client(this);
        connect(socket, SIGNAL(synced()), this, SLOT(sendSyncedSignal()));
        socket->syncMenu(ip);
    }
}

bool SyncManager::isNeedSync()
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER, synced INTEGER)");
    query.exec("SELECT * FROM deviceDB WHERE synced = 0");

    if (query.next()) {
        return true;
    }
    else {
        return false;
    }
}

void SyncManager::sendNeedSyncSignal()
{
    emit needSync();
}

void SyncManager::setSyncOn()
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER, synced INTEGER)");
    query.exec("UPDATE deviceDB SET synced = 0");
}

void SyncManager::sendSyncedSignal()
{
    emit haveSynced();
}
