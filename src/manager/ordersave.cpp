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
      //��ȡMAC��ַ
}

void OrderSave::saveData(qint32 orderNo,qint32 seatNo,float discount){
    QDate date;
    QTime time;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seatNO INTEGER, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");

    query.prepare("INSERT INTO orderListDB(orderNO, seatNO, mac, date, time, discount, total, pay) VALUES(?, ?, ?, ?, ?, ?, ?, ?)");
    query.addBindValue(orderNo);
    query.addBindValue(seatNo);
    query.addBindValue(mac);
    query.addBindValue(date);
    query.addBindValue(time);
    query.addBindValue(discount);
    query.addBindValue(0);
    query.addBindValue(0);
    query.exec();
}
void OrderSave::changeData(qint32 orderNo,qint32 seatNo,float discount){
    QDate date;
    QTime time;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seatNO INTEGER, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");

/*    query.prepare("UPDATE orderListDB SET(orderNO, seatNO, date, time, discount) VALUES(?, ?, ?, ?, ?) WHERE orderNO = ?");
    query.addBindValue(orderNo);
     query.addBindValue(seatNo);
    query.addBindValue(date);
    query.addBindValue(time);
    query.addBindValue(discount);
    query.addBindValue(oldorder);*/ //������ͬʱ���¶��ֵ

    if(seatNo != -1) {
    query.prepare("UPDATE orderListDB SET seatNO = ? WHERE orderNO = ?");
    query.addBindValue(seatNo);
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
