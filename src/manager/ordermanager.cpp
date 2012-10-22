#include "ordermanager.h"
#include <QDebug>
#include <QtSql>

OrderManager::OrderManager(QObject *parent) :
    QObject(parent)
{

}

void OrderManager::payOrder(QString oid)
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(oid TEXT key, orderNO INTEGER, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    query.prepare("UPDATE orderListDB SET pay = ? WHERE oid = ?");
    query.addBindValue(1);
    query.addBindValue(oid);
    query.exec();

    emit pay(oid);
}

QString  OrderManager::genManualOrder()
{/*
    QString oid;
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS manuaOrder(oid INTEGER key)");
    query.exec("select * from manuaOrder");
    while ( query.next() )
    {
        orderNo = query.value(0).toInt();
        orderNo++;
        return orderNo;
    }
    orderNo = 900000000;
    return orderNo;*/
    return "";
}

void OrderManager::saveManualOrder(qint32 orderNo)
{
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS manuaOrder(orderNO INTEGER key)");
    query.exec("select * from manuaOrder");
    if ( query.next() )
    {
        query.prepare("UPDATE manuaOrder SET orderNO = ? ");
        query.addBindValue(orderNo);
        query.exec();
    }
    else
    {
        query.prepare("insert into manuaOrder (orderNO) values(?)");
        query.addBindValue(orderNo);
        query.exec();
     }
}

quint32 OrderManager::getNextOrderNO()
{
    quint32 orderNO = 100000000;
    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(oid TEXT key, orderNO INTEGER, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    query.exec("SELECT MAX(orderNO) FROM orderListDB");
    if (query.next()) {
        if (!query.isNull(0)) {
            orderNO = query.value(1).toUInt();
            qDebug() << "ordermanager" << orderNO ;
        }
    }

    orderNO++;
    return orderNO;
}
