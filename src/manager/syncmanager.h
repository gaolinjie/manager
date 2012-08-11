#ifndef SYNCMANAGER_H
#define SYNCMANAGER_H

#include <QObject>

class SyncManager : public QObject
{
    Q_OBJECT
public:
    explicit SyncManager(QObject *parent = 0);
    
signals:
    void needSync();
    void haveSynced();
    
public slots:
    void syncMenu();
    bool isNeedSync();
    void sendNeedSyncSignal();
    void setSyncOn();
    void sendSyncedSignal();

private:
};

#endif // SYNCMANAGER_H
