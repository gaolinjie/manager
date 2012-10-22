#include <QtNetwork>
#include <QtSql>
#include <QDebug>
#include <QDateTime>

#include "clientsocket.h"
#include "client.h"
#include "ordermanager.h"

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
    QString oid = "";
    QString seat = "";
    QString mac;
    QDate date;
    QTime time;
    qreal discount = 0;
    qreal total = 0;

    QString iid = "";
    QString tid = "";
    QString type = "";
    QString name = "";
    QString image = "";
    float price = 0;
    quint16 print = 0;
    QString printer = "";
    quint16 num = 0;

    QSqlQuery query;

    in >> oid >> seat >> mac;
    qDebug() << oid << seat;
    QDateTime *datatime=new QDateTime(QDateTime::currentDateTime());
    date = datatime->date();
    time = datatime->time();

    quint32 flag;
    while(in >> flag, flag != 0xFFFF)
    {
        in >> iid >> tid >> type >> name >> image >> price >> print >> printer >> num;
        total += price * num;

        query.exec("CREATE TABLE IF NOT EXISTS orderItemDB(oid TEXT key, iid TEXT, tid TEXT, type TEXT, name TEXT, image TEXT, price REAL, print INTEGER, printer TEXT, num INTEGER)");
        query.prepare("INSERT INTO orderItemDB(oid, iid, tid, type, name, image, price, print, printer, num) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)");
        query.addBindValue(oid);
        query.addBindValue(iid);
        query.addBindValue(tid);
        query.addBindValue(type);
        query.addBindValue(name);
        query.addBindValue(image);
        query.addBindValue(price);
        query.addBindValue(print);
        query.addBindValue(printer);
        query.addBindValue(num);
        query.exec();
    }

    query.exec("CREATE TABLE IF NOT EXISTS orderListDB(oid TEXT key, orderNO INTEGER, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    query.prepare("SELECT * FROM orderListDB WHERE oid = ?");
    query.addBindValue(oid);
    query.exec();

    if (query.next())
    {
        qreal preTotal = query.value(7).toReal();
        total += preTotal;

        query.prepare("UPDATE orderListDB SET total = ? WHERE oid = ?");
        query.addBindValue(total);
        query.addBindValue(oid);
        query.exec();
    }
    else
    {
        quint32 orderNO = OrderManager::getNextOrderNO();
        qDebug() << "clientsocket" << orderNO;
        query.prepare("INSERT INTO orderListDB(oid, orderNO, seat, mac, date, time, discount, total, pay) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)");
        query.addBindValue(oid);
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
