#ifndef SIGNALMANAGER_H
#define SIGNALMANAGER_H
#include <QObject>
class SignalManager : public QObject
{
    Q_OBJECT
public:
    explicit SignalManager(QObject *parent = 0);
    Q_INVOKABLE void  sendPrinterChange();
    Q_INVOKABLE void  sendPrinterGridModelChange();
signals:
    void printerChanged();
    void printerGridModelChange();
public slots:

};
#endif // SIGNALMANAGER_H
