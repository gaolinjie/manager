#ifndef CLIENT_H
#define CLIENT_H

#include <QObject>
#include <QTcpSocket>
#include <QUdpSocket>
#include <QDir>

class Client : public QTcpSocket
{
    Q_OBJECT
public:
    explicit Client(QObject *parent = 0);
    ~Client();
    
public slots:
    void syncMenu(const QString &ip);

private slots:
    void sendData();
    void getData();
    void connectionClosedByServer();
    void error();

private:
    void connectToServer(const QString &ip);
    void closeConnection();

    quint16 nextBlockSize;
    QByteArray *block;

    quint16 mImageIndex;
    QStringList mImageList;
    QDir mImageDir;
};

#endif // CLIENT_H