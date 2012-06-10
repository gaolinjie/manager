#ifndef IMAGEMANAGER_H
#define IMAGEMANAGER_H

#include <QObject>
#include <QDir>

class ImageManager : public QObject
{
    Q_OBJECT
public:
    explicit ImageManager(QObject *parent = 0);
    
signals:
    
public slots:
    void construct();
    void deconstruct();
    quint16 getCount();
    QString getImage(quint16 index);
    QString getImageName(quint16 index);

private:
    QStringList mImageList;
    QDir mImageDir;
};

#endif // IMAGEMANAGER_H
