#include "signalmanager.h"
#include <QDebug>
#include <QtSql>

SignalManager::SignalManager(QObject *parent) :
    QObject(parent)
{
}

void SignalManager::sendPrinterChange()
{
    emit printerChanged();
}
void SignalManager::sendPrinterGridModelChange()
{
    emit printerGridModelChange();
}
