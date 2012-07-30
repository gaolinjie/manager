#include "idmanager.h"
#include "QUuid"

IDManager::IDManager(QObject *parent) :
    QObject(parent)
{
    mUniqueShopcarID = "{8688b9c3-a33a-4ff6-b7b0-9300c6bbb689}";
    mUniqueSeatID = "{dcb58182-5e0a-481a-9e0c-aeace8b92f39}";
}

QString IDManager::createID()
{
    QUuid uuid = QUuid::createUuid();
    QString suuid = uuid.toString();
    return suuid;
}

QString IDManager::getUniqueShopcarID()
{
    return mUniqueShopcarID;
}

QString IDManager::getUniqueSeatID()
{
    return mUniqueSeatID;
}
