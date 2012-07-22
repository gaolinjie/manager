#include "client.h"
#include <QtNetwork>
#include <QtSql>

Client::Client(QObject *parent)
    : QTcpSocket(parent)
{
    connect(this, SIGNAL(connected()), this, SLOT(sendData()));
    connect(this, SIGNAL(disconnected()),
            this, SLOT(connectionClosedByServer()));
    connect(this, SIGNAL(readyRead()),
            this, SLOT(getData()));
    connect(this, SIGNAL(error(QAbstractSocket::SocketError)),
            this, SLOT(error()));
}

Client::~Client()
{
    delete block;
    block = 0;
}

void Client::connectToServer(const QString &ip)
{
    connectToHost(ip, 6177);
    nextBlockSize = 0;
}

void Client::sendData()
{
    write(*block);

    QDataStream out(this);
    out.setVersion(QDataStream::Qt_4_7);

    qint16 count = mImageList.size();
    out << count;

    for (mImageIndex=0; mImageIndex<mImageList.size(); mImageIndex++) {
        QString imageName = mImageList.at(mImageIndex);
        QFile file(mImageDir.path() + "/" + imageName);
        if (!file.open(QIODevice::ReadOnly))
        {
            qDebug() << "file.open failed!";
            return;
        }

        QByteArray ba = file.readAll();
        quint32 size = ba.size() + imageName.size();
        qDebug() << size;
        out << size;
        out << imageName;
        out << ba;
        file.close();
    }

    delete block;
    block = 0;
}

void Client::getData()
{
}

void Client::connectionClosedByServer()
{
    if (nextBlockSize != 0xFFFF){}
    closeConnection();
}

void Client::error()
{
    closeConnection();
}

void Client::closeConnection()
{
    close();
}

void Client::syncMenu(const QString &ip)
{
    QStringList filters;
    filters << "*.png";
    mImageDir.setPath("C:/Users/gao/pics/"); // Windows
    mImageDir.setNameFilters(filters);
    mImageList = mImageDir.entryList ();
    mImageIndex = 0;



    QString imagePath = "file:///C:/Users/gao/pics/";
    block = new QByteArray();
    QDataStream out(block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_7);
    out << quint16(0) << quint8('X');

    QSqlQuery query;
    query.exec("SELECT COUNT(*) FROM startModel");
    quint16 cnum = 0;
    if (query.next()) {
        cnum = query.value(0).toUInt();
    }
    query.exec("SELECT COUNT(*) FROM itemModel");
    quint16 inum = 0;
    if (query.next()) {
        inum = query.value(0).toUInt();
    }
    out << cnum << inum;

    query.exec("SELECT * FROM startModel");

    quint16 cid = 0;
    QString title = "";
    QString image = "";
    QString style = "";
    QString slotQml = "";
    QString backColor = "";
    QString foreColor = "";
    while (query.next()) {
        cid = query.value(0).toUInt();
        title = query.value(1).toString();
        image = query.value(2).toString();
        image.remove(imagePath);
        style = query.value(3).toString();
        slotQml = query.value(4).toString();
        backColor = query.value(5).toString();
        foreColor = query.value(6).toString();
        out << cid << title << image << style
            << slotQml << backColor << foreColor;
        cnum++;
    }

    query.exec("SELECT * FROM itemModel");

    quint16 iid = 0;
    QString tag = "";
    QString name = "";
    QString detail = "";
    float price = 0;
    while (query.next()) {
        iid = query.value(0).toUInt();
        cid = query.value(1).toUInt();
        tag = query.value(2).toString();
        name = query.value(3).toString();
        image = query.value(4).toString();
        image.remove(imagePath);
        detail = query.value(5).toString();
        price = query.value(6).toFloat();
        out << iid << cid << tag << name
            << image << detail << price;
        inum++;
    }

    //out << 0xFFFF;

    out.device()->seek(0);
    out << quint16(block->size() - sizeof(quint16));

    connectToServer(ip);
}
