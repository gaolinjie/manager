#ifndef SYNCMANAGER_H
#define SYNCMANAGER_H

#include <QObject>

class SyncManager : public QObject
{
    Q_OBJECT
public:
    explicit SyncManager(QObject *parent = 0);
    
signals:
    
public slots:
    void syncMenu();
    bool isNeedSync();
};

#endif // SYNCMANAGER_H
