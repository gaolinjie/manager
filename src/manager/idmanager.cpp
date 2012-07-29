#include "idmanager.h"
#include "QUuid"

IDManager::IDManager(QObject *parent) :
    QObject(parent)
{
}

QString IDManager::createID()
{
    QUuid uuid = QUuid::createUuid();
    QString suuid = uuid.toString();
    return suuid;
}
