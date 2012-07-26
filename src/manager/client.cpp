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

    mIsSyncing = false;
}

Client::~Client()
{
    delete block;
    block = 0;
}

void Client::sendPaiedOrder(quint32 orderNO)
{
    block = new QByteArray();
    QDataStream out(block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_7);

    QSqlQuery query;
    query.prepare("SELECT * FROM orderListDB WHERE orderNO = ?");
    query.addBindValue(orderNO);
    query.exec();

    QString mac;
    if (query.next())
    {
        mac = query.value(2).toString();
    }

    query.prepare("SELECT * FROM deviceDB WHERE mac = ?");
    query.addBindValue(mac);
    query.exec();

    QString ip;
    if (query.next())
    {
        ip = query.value(1).toString();
    }

    out << quint16(0) << quint8('S') << orderNO << 0xFFFF;

    out.device()->seek(0);
    out << quint16(block->size() - sizeof(quint16));

    connectToServer(ip);
}

void Client::sendDeviceNO(quint32 deviceNO)
{
    block = new QByteArray();
    QDataStream out(block, QIODevice::WriteOnly);
    out.setVersion(QDataStream::Qt_4_7);

    // get device ip
    QSqlQuery query;
    query.prepare("SELECT * FROM deviceDB WHERE deviceNO = ?");
    query.addBindValue(deviceNO);
    query.exec();

    QString deviceIP;
    if (query.next())
    {
        deviceIP = query.value(1).toString();
    }

    // Begin Issue #4, gaolinjie, 2012-04-10 //
    // get host ip
    QString hostIP;
#ifdef WIN32
//  Windows code here
    QString localHostName = QHostInfo::localHostName();
    QHostInfo info = QHostInfo::fromName(localHostName);
    foreach(QHostAddress address,info.addresses())
    {
         if(address.protocol() == QAbstractSocket::IPv4Protocol)
         {
             hostIP = address.toString();
         }
    }
#else
//  UNIX code here
    QNetworkInterface *qni;
    qni = new QNetworkInterface();
    *qni = qni->interfaceFromName(QString("%1").arg("wlan0"));
    hostIP = qni->addressEntries().at(0).ip().toString();
#endif
    // End Issue #4 //

    out << quint16(0) << quint8('R') << deviceNO << hostIP << 0xFFFF;

    out.device()->seek(0);
    out << quint16(block->size() - sizeof(quint16));

    connectToServer(deviceIP);
}

void Client::connectToServer(const QString &ip)
{
    connectToHost(ip, 6177);
    nextBlockSize = 0;
}

void Client::sendData()
{
    write(*block);

    if (mIsSyncing) {
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
    }

    delete block;
    block = 0;
}

void Client::getData()
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
    QString mac;

    in >> requestType >> mac;
    if (requestType == 'X')
    {
        QSqlQuery query;
        query.prepare("UPDATE deviceDB SET synced = ? WHERE mac = ?");
        query.addBindValue(1);
        query.addBindValue(mac);
        query.exec();
        qDebug() << "synced";
    }
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
    query.exec("SELECT COUNT(*) FROM menuTypeDB");
    quint16 cnum = 0;
    if (query.next()) {
        cnum = query.value(0).toUInt();
    }
    query.exec("SELECT COUNT(*) FROM menuItemDB");
    quint16 inum = 0;
    if (query.next()) {
        inum = query.value(0).toUInt();
    }
    out << cnum << inum;

    query.exec("SELECT * FROM menuTypeDB");

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

    query.exec("SELECT * FROM menuItemDB");

    quint16 iid = 0;
    QString tag = "";
    QString name = "";
    QString detail = "";
    quint16 needPrint = 0;
    QString printer = "";
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
        needPrint = query.value(7).toUInt();
        printer = query.value(8).toString();
        out << iid << cid << tag << name
            << image << detail << price
            << needPrint << printer;
        inum++;
    }

    //out << 0xFFFF;

    out.device()->seek(0);
    out << quint16(block->size() - sizeof(quint16));

    mIsSyncing = true;
    connectToServer(ip);
}
