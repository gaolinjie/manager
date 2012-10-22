#ifndef ORDERMANAGER_H
#define ORDERMANAGER_H

#include <QObject>

class OrderManager : public QObject
{
    Q_OBJECT
public:
    explicit OrderManager(QObject *parent = 0);

    Q_INVOKABLE QString  genManualOrder();
    Q_INVOKABLE void  saveManualOrder(qint32 orderNo);

signals:
    void pay(QString oid);

public slots:
    void payOrder(QString oid);
    static quint32 getNextOrderNO();
};

#endif // ORDERMANAGER_H
