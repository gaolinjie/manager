#include "syncmanager.h"
#include "client.h"

SyncManager::SyncManager(QObject *parent) :
    QObject(parent)
{
}

void SyncManager::syncMenu()
{
    QString ip = "";
    Client *socket = new Client(this);
    socket->syncMenu(ip);
}
