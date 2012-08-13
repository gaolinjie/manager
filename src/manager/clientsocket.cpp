#include <QtNetwork>
#include <QtSql>
#include <QDebug>
#include <QDateTime>

#include "clientsocket.h"
#include "client.h"

ClientSocket::ClientSocket(QObject *parent)
    : QTcpSocket(parent)
{
    connect(this, SIGNAL(readyRead()), this, SLOT(readClient()));
    connect(this, SIGNAL(disconnected()), this, SLOT(deleteLater()));

    nextBlockSize = 0;
}

void ClientSocket::readClient()
{
    QDataStream in(this);
    in.setVersion(QDataStream::Qt_4_7);

    if (nextBlockSize == 0)
    {
        if (bytesAvailable() < sizeof(quint16))
            return;
        in >> nextBlockSize;
    }

    if (bytesAvailable() < nextBlockSize)
        return;

    quint8 requestType = 0;

    in >> requestType;
    if (requestType == 'O')
    {
        readOrder(in);
    }

    close();
}

void ClientSocket::readOrder(QDataStream &in)
{
    quint32 orderNO = 0;
    QString seat = "";
    QString mac;
    QDate date;
    QTime time;
    qreal discount = 0;
    qreal total = 0;

    QString name;
    qreal price;
    quint16 num;

    QSqlQuery query;

    in >> orderNO >> seat >> mac;
    qDebug() << orderNO << seat;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    quint32 flag;
    while(in >> flag, flag != 0xFFFF)
    {
        in >> name >> price >> num;
        total += price * num;

        qDebug() << QString("%1").arg(name) << QString("%1").arg(price) << QString("%1").arg(num);

        query.exec("CREATE TABLE IF NOT EXISTS orderItemDB(orderNO INTEGER key, name TEXT, price REAL, num INTEGER)");
        query.prepare("INSERT INTO orderItemDB(orderNO, name, price, num) VALUES (?, ?, ?, ?)");
        query.addBindValue(orderNO);
        query.addBindValue(name);
        query.addBindValue(price);
        query.addBindValue(num);
        query.exec();
    }

    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    query.prepare("SELECT * FROM orderListDB WHERE orderNO = ?");
    query.addBindValue(orderNO);
    query.exec();

    if (query.next())
    {
        qreal preTotal = query.value(6).toReal();
        total += preTotal;

        query.prepare("UPDATE orderListDB SET total = ? WHERE orderNO = ?");
        query.addBindValue(total);
        query.addBindValue(orderNO);
        query.exec();
    }
    else
    {
        query.prepare("INSERT INTO orderListDB(orderNO, seat, mac, date, time, discount, total, pay) VALUES (?, ?, ?, ?, ?, ?, ?, ?)");
        query.addBindValue(orderNO);
        query.addBindValue(seat);
        query.addBindValue(mac);
        query.addBindValue(date);
        query.addBindValue(time);
        query.addBindValue(discount);
        query.addBindValue(total);
        query.addBindValue(0);
        query.exec();
    }

    emit dbChanged();
}
/*
void ClientSocket::readRegistration(QDataStream &in)
{
    quint32 deviceNO = 100;
    QString mac;
    QString ip;
    in >> mac >> ip;
    qDebug() << mac << ip;

    QSqlQuery query;
    query.exec("CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER)");
    query.prepare("SELECT * FROM deviceDB WHERE mac = ?");
    query.addBindValue(mac);
    query.exec();

    if (query.next())
    {
        deviceNO = query.value(2).toUInt();
        query.prepare("UPDATE deviceDB SET ip = ? WHERE mac = ?");
        query.addBindValue(ip);
        query.addBindValue(mac);
        query.exec();
    }
    else
    {
        query.exec("select max(deviceNO) from deviceDB");
        if (query.next())
        {
            deviceNO = query.value(0).toUInt();
        }
        deviceNO++;

        query.prepare("INSERT INTO deviceDB(mac, ip, deviceNO) VALUES (?, ?, ?)");
        query.addBindValue(mac);
        query.addBindValue(ip);
        query.addBindValue(deviceNO);
        query.exec();
    }

    emit registering(deviceNO);
}*/
