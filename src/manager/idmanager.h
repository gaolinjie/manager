#ifndef IDMANAGER_H
#define IDMANAGER_H

#include <QObject>

class IDManager : public QObject
{
    Q_OBJECT
public:
    explicit IDManager(QObject *parent = 0);
    
signals:
    
public slots:
    QString createID();
    QString getUniqueShopcarID();
    QString getUniqueSeatID();

private:
    QString mUniqueShopcarID;
    QString mUniqueSeatID;
};

#endif // IDMANAGER_H
