#include "syncmanager.h"
#include "client.h"
#include <QtSql>

SyncManager::SyncManager(QObject *parent) :
    QObject(parent)
{
}

void SyncManager::syncMenu()
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER, synced INTEGER)");
    query.exec("SELECT * FROM deviceDB WHERE synced = 0");

    QString ip = "";
    while (query.next())
    {
        ip = query.value(1).toString();
        Client *socket = new Client(this);
        socket->mIsSyncing = true;
        socket->syncMenu(ip);
    }
}
