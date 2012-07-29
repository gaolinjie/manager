#include "imagemanager.h"
#include <QDebug>

ImageManager::ImageManager(QObject *parent) :
    QObject(parent)
{
}

void ImageManager::construct()
{
    QStringList filters;
    filters << "*.png";
    //mImageDir.setPath(QDir::homePath()+"/Pictures/manager"); // Linux
    mImageDir.setPath("C:/manager"); // Windows
    mImageDir.setNameFilters(filters);
    mImageList = mImageDir.entryList ();
}

void ImageManager::deconstruct()
{
}

quint16 ImageManager::getCount()
{
    if (mImageList.empty()) {
        return 0;
    }
    else {
        return mImageList.size();
    }
}

QString ImageManager::getImage(quint16 index)
{
    if (mImageList.empty()) {
        return "";
    }
    else {
        return "file:///" + mImageDir.path() + "/" + mImageList.at(index);
    }
}

QString ImageManager::getImageName(quint16 index)
{
    if (mImageList.empty()) {
        return "";
    }
    else {
        return mImageList.at(index);
    }
}
