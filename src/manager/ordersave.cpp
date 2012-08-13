#include "ordersave.h"
#include <QtSql>
#include <QDebug>
#include <QDateTime>
#include <QtNetwork>

OrderSave::OrderSave(QObject *parent) :
    QObject(parent)
{
      QNetworkInterface *qni;
      qni = new QNetworkInterface();
      *qni = qni->interfaceFromName(QString("%1").arg("eth0"));
      mac = qni->hardwareAddress();
      //»ñÈ¡MACµØÖ·
}

void OrderSave::saveData(qint32 orderNo,QString seat,float discount)
{
    QDate date;
    QTime time;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");

    query.prepare("INSERT INTO orderList(orderNO, seat, mac, date, time, discount, total, pay) VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue(orderNo);
    query.addBindValue(seat);
    query.addBindValue(mac);
    query.addBindValue(date);
    query.addBindValue(time);
    query.addBindValue(discount);
    query.addBindValue(0);
    query.addBindValue(0);
    query.exec();
}

void OrderSave::changeData(qint32 orderNo,QString seat,float discount){
    QDate date;
    QTime time;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");

    if(seat != "") {
    query.prepare("UPDATE orderListDB SET seat = ? WHERE orderNO = ?");
    query.addBindValue(seat);
    query.addBindValue(orderNo);
    query.exec();
    }
    if (discount!=-1){
    query.prepare("UPDATE orderListDB SET discount = ? WHERE orderNO = ?");
    query.addBindValue(discount);
    query.addBindValue(orderNo);
    query.exec();
    }
}
