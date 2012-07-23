#ifndef PRINTER_H
#define PRINTER_H

#include <QObject>

#include <qstringlist.h>
#include <qstring.h>

class Printer : public QObject
{
    Q_OBJECT
public:
    explicit Printer(QObject *parent = 0);
    Q_INVOKABLE void printMenutoPdf(QStringList);

    Q_INVOKABLE void printMenutoKitchen(quint32);
    Q_INVOKABLE void printMenutoForeground(quint32, QString, QString, QString);

    QString printerList();
    
signals:
    
public slots:
    
};

#endif // PRINTER_H
