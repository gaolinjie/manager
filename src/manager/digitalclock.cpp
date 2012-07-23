#include "digitalclock.h"

DigitalClock::DigitalClock(QObject *parent) :
    QObject(parent)
{
    timer = new QTimer(this);
    timerUpDate();
    connect(timer,SIGNAL(timeout()),this,SLOT(timerUpDate()));
}

void DigitalClock::timerUpDate()
{
    datatime = QDateTime::currentDateTime();

    int y=datatime.date().year();
    int m=datatime.date().month();
    int d=datatime.date().day();
    QDate wdate(y,m,d);
    int temp=wdate.dayOfWeek();
    switch(temp)
    {
        case(1):
        weekday = tr("һ");
            break;
        case(2):
        weekday = tr("��");
            break;
        case(3):
        weekday = tr("��");
            break;
        case(4):
        weekday = tr("��");
            break;
        case(5):
        weekday = tr("��");
            break;
        case(6):
        weekday = tr("��");
            break;
        case(7):
        weekday = tr("��");
            break;
        default:
            break;
    }
    year = QString::number(y);
    month= QString::number(m);
    date = QString::number(d);
    time = datatime.toString("hh:mm");
    timer->start(5000);
}

QString DigitalClock::getYear()
{
    return year;
}
QString DigitalClock::getMonth()
{
    return month;
}
QString DigitalClock::getDate()
{
    return date;
}
QString DigitalClock::getWeek()
{
    return weekday;
}
QString DigitalClock::getTime()
{
    return time;
}
