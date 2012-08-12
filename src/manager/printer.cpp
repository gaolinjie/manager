#include <string.h>
#include <qstringlist.h>
#include <qstring.h>
#include <qdesktopservices.h>
#include <qfiledialog.h>
#include <qtextdocument.h>
#include <qtextcodec.h>
#include <QPrintDialog>
#include <QPrinterInfo>
#include <QDebug>
#include <QtGui>
#include <QDateTime>
#include <QtCore>
#include <QtSql>

#include "printer.h"

Printer::Printer(QObject *parent) :
    QObject(parent)
{

}

void Printer::printMenutoPdf(QStringList menu) {
    QStringList m_menu = menu;
    QString m_title = QObject::tr(" &nbsp;�����Ͼ��½ֿڵ�");
    QString m_time = QDateTime::currentDateTime().toString("yy-MM-dd hh:mm:ss");
    QString m_opeartor = QObject::tr("ղķ˹"); //get from POS
    QString m_html;

    double m_totalcost = 0;
    int m_sitnum = 1;    //get from tablet
    int m_totalitems = 0;
    int m_totalget = 200; //hard code here

    m_html += "<h2 align=\"center\"><font size=\"+2\">" + m_title + "</font></h2>";
    m_html += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("����ʱ��: ") + m_time + "</font></div>";
    m_html += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("��λ��: ") + QString::number(m_sitnum, 'g', 6)
              + "</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
              + QObject::tr("����Ա: ") + m_opeartor + "</div>";
    m_html += "<hr  width=\"50%\" size =\"15\">";
    m_html += "<table align=\"center\" border=\"0\" cellspacing=\"12\" width=\"50%\"><tr  bgcolor=\"lightgray\"><th>" + QObject::tr("����") + "</th><th>" + QObject::tr("����")
              + "</th><th>" + QObject::tr("����") + "</th><th>" + QObject::tr("���") + "</th></tr>";

    foreach (QString entry, m_menu) {
        bool ok;
        ++m_totalitems;
        QStringList fields = entry.split(":");
        QString m_name = QObject::tr(Qt::escape(fields[0]).toStdString().c_str());
        QString m_unitprice = Qt::escape(fields[1]);
        QString m_num = Qt::escape(fields[2]);
        QString m_ammount = QString::number((m_num.toDouble(&ok))*(m_unitprice.toDouble(&ok)), 'g', 6);
        m_totalcost += m_ammount.toDouble(&ok);
        m_html += "<tr><td align=\"center\">" + m_name + "</td><td align=\"center\">" + m_unitprice +
                "</td><td align=\"center\">" + m_num + "</td><td align=\"center\"><font size=\"+1\">" + m_ammount + "</font></td></tr>";
    }

    m_html += "</table>";
    m_html += "<hr  width=\"50%\" size=\"15\">";
    m_html += "<div align=\"center\">" + QObject::tr("�ܼ�: &nbsp;&nbsp;")
               + "<font size=\"+2\">" + QString::number(m_totalcost, 'g', 6) + "</font>&nbsp;&nbsp;&nbsp;&nbsp;"
               + QObject::tr("������: &nbsp;&nbsp;") + "<font size=\"+1\">" + QString::number(m_totalitems, 'g', 6) + "</font></div>";
    m_html += "<div align=\"center\">" + QObject::tr("Ԥ��: &nbsp;&nbsp;") + "<font size=\"+2\">" + QString::number(m_totalget, 'g', 6) + "</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
               + QObject::tr("����: &nbsp;&nbsp;") + "<font size=\"+2\">" + QString::number(m_totalget-m_totalcost, 'g', 6) + "</font></div>";
    m_html += "<p align=\"center\">" + QObject::tr("*���׻�ӭ���ٴι���*") + "</p>";
    m_html += "<div align=\"center\">" + QObject::tr("�������ߣ�&nbsp;&nbsp;88888888") + "</div>";

    //debug: to get the html content
    qDebug(m_html.toUtf8());

    //debug: to get available printer in local area
    QString m_printers = Printer::printerList();
    qDebug(m_printers.toUtf8());

    //find the wanted network printer to print
    QPrinterInfo printerInfo = QPrinterInfo();
    QPrinterInfo targetPrinterInfo = QPrinterInfo();

    foreach(QPrinterInfo item, printerInfo.availablePrinters()){
        if(item.printerName() == QString::fromStdString("HP_LaserJet_P4014.P4015_PCL6:3")){
            //m_printer = new QPrinter(item, QPrinter::HighResolution);
            targetPrinterInfo = item;
            qDebug(targetPrinterInfo.printerName().toUtf8());
            break;
        }else{
            qDebug("nothing!!!");
        }
    }

    //QPrinter m_printer(targetPrinterInfo, QPrinter::HighResolution);
    QPrinter  m_printer(QPrinter::HighResolution);

    //m_printer.setOutputFormat(QPrinter::NativeFormat);
    m_printer.setOutputFileName("/home/ljl/menu.pdf");

    QTextDocument m_textDocument;
    m_textDocument.setHtml(m_html); //QTextDocument::setPlainText(const QString &text)
    m_textDocument.setPageSize(QSizeF(m_printer.logicalDpiX()*(75/50),
                                  m_printer.logicalDpiY()*(75/50)));
    m_textDocument.print(&m_printer);

}

void Printer::printMenutoKitchen(quint32 orderNum){
    quint32 mOrderNum = orderNum;
    QString m_htmlhead;
    QString m_htmlbody="";
    QString m_htmlfinal="";
    QString m_html="";
    QSqlQuery queryOrderList;
    QSqlQuery queryOrderItem;

    QString m_time = QDateTime::currentDateTime().toString("yy-MM-dd hh:mm:ss");
    QString m_opeartor = QObject::tr("ղķ˹"); //get from POS
    int m_seatNo = 0;
  //  float discount = 0;

    //ͨ��orderNum����ѯorderListDB���е���λ��
    queryOrderList.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seatNO INTEGER, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    queryOrderList.prepare("SELECT * FROM orderListDB WHERE orderNO = ?");
    queryOrderList.addBindValue(mOrderNum);
    queryOrderList.exec();
    // Ϊ���������˵���ֻ���������š���λ�š������Ͷ�Ӧ������
    m_htmlhead += "<h2 align=\"center\"><font size=\"+1\">" + QObject::tr("������: ")  + QString::number(mOrderNum)  + "</font></h2>";
    m_htmlhead += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("����ʱ��: ") + m_time + "</font></div>";

    if(queryOrderList.next()){
        m_seatNo = queryOrderList.value(1).toInt();
     //   discount =   queryOrderList.value(5).toFloat();
    }
    m_htmlhead += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("��λ��: ") + QString::number(m_seatNo)
              + "</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
              + QObject::tr("����Ա: ") + m_opeartor + "</div>";
    m_htmlhead += "<hr  width=\"90%\" size =\"15\">";
    m_htmlhead += "<table align=\"center\" border=\"0\" cellspacing=\"12\" width=\"100%\"><tr bgcolor=\"lightgray\"><th>" + QObject::tr("����")
            + "</th><th>" + QObject::tr("����") + "</th></tr>";

    m_htmlfinal += "</table>";
    m_htmlfinal += "<hr  width=\"90%\" size=\"15\">";

    //debug: to get available printer in local area
//        QString m_printers = printerList();
//        qDebug(m_printers.toUtf8());

    //find the wanted network printer to print
    QPrinterInfo printerInfo = QPrinterInfo();
    QPrinterInfo targetPrinterInfo = QPrinterInfo();
    foreach(QPrinterInfo item, printerInfo.availablePrinters()){
        m_htmlbody = "";
        m_html = "";
        queryOrderItem.exec("CREATE TABLE IF NOT EXISTS orderItemDB(orderNO INTEGER key,name TEXT, price REAL, num INTEGER, type INTEGER,printname TEXT,printbool INTEGER,cookbool INTEGER)");
        queryOrderItem.prepare("SELECT * FROM orderItemDB WHERE orderNO = ? AND printname = ? AND cookbool = ?");
        queryOrderItem.addBindValue(mOrderNum);
        queryOrderItem.addBindValue(item.printerName());
        queryOrderItem.addBindValue(0);
        queryOrderItem.exec();
        while (queryOrderItem.next())
        {
            QString name = queryOrderItem.value(1).toString();//colume 1 �ڱ�orderItemDB�ж�Ӧ����
            quint16 num = queryOrderItem.value(3).toInt();    //colume 3 �ڱ�orderItemDB�ж�Ӧĳ���˵�����
            m_htmlbody += "<tr><td align=\"center\">" + name
                    + "</td><td align=\"center\">"+QString::number(num) + "</td></tr>";
        }

        if (m_htmlbody != "")
        {
           m_html += m_htmlhead;
           m_html += m_htmlbody;
           m_html += m_htmlfinal;
           targetPrinterInfo = item;
           QPrinter m_printer(targetPrinterInfo, QPrinter::HighResolution);
           qDebug(targetPrinterInfo.printerName().toUtf8());
           QTextDocument m_textDocument;
           m_textDocument.setHtml(m_html); //QTextDocument::setPlainText(const QString &text)
           m_textDocument.setPageSize(QSizeF(m_printer.logicalDpiX()*(30/25.4),
                                                     m_printer.logicalDpiY()*(115/25.4)));
           m_textDocument.print(&m_printer);

        }
        //else qDebug("789");
    }
}

void Printer::printMenutoForeground(quint32 orderNum, QString renderMoney, QString giveMoney, QString changeMoney){
    quint32 mOrderNum = orderNum;
    QString m_html;
    QSqlQuery queryOrderList;
    QSqlQuery queryOrderItem;

    QString m_title = QObject::tr(" &nbsp;�����Ͼ��½ֿڵ�");
    QString m_time = QDateTime::currentDateTime().toString("yy-MM-dd hh:mm:ss");
    QString m_opeartor = QObject::tr("ղķ˹"); //get from POS
    int m_seatNo = 0;
    float  totalPrice=0;
    float discount = 0;

    m_html += "<h2 align=\"center\"><font size=\"+2\">" + m_title + "</font></h2>";
    //ͨ��orderNum����ѯOrderList���е���λ��
    queryOrderList.exec("CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seatNO INTEGER, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)");
    queryOrderList.prepare("SELECT * FROM orderListDB WHERE orderNO = ?");
    queryOrderList.addBindValue(mOrderNum);
    queryOrderList.exec();
    // Ϊ���������˵���ֻ���������š���λ�š������Ͷ�Ӧ������
    m_html += "<h2 align=\"center\"><font size=\"+1\">" + QObject::tr("������: ")  + QString::number(mOrderNum)  + "</font></h2>";
    m_html += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("����ʱ��: ") + m_time + "</font></div>";

    if(queryOrderList.next()){
        m_seatNo = queryOrderList.value(1).toInt();
        discount =   queryOrderList.value(5).toFloat();
    }
    m_html += "<div align=\"center\"><font size=\"+0\">" + QObject::tr("��λ��: ") + QString::number(m_seatNo)
              + "</font>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;"
              + QObject::tr("����Ա: ") + m_opeartor + "</div>";
    m_html += "<hr  width=\"90%\" size =\"15\">";
    m_html += "<table align=\"center\" border=\"0\" cellspacing=\"12\" width=\"100%\"><tr bgcolor=\"lightgray\"><th>" + QObject::tr("����")
            + "</th><th>" + QObject::tr("�۸�") + "</th><th>" + QObject::tr("����") + "</th><th>" + QObject::tr("С��") + "</th></tr>";

    queryOrderItem.exec("CREATE TABLE IF NOT EXISTS orderItemDB(orderNO INTEGER key,name TEXT, price REAL, num INTEGER, type INTEGER,printname TEXT,printbool INTEGER,cookbool INTEGER)");
    queryOrderItem.prepare("SELECT * FROM orderItemDB WHERE orderNO = ?");
    queryOrderItem.addBindValue(mOrderNum);
    queryOrderItem.exec();

    while (queryOrderItem.next())
    {
        QString name = queryOrderItem.value(1).toString();//colume 1 �ڱ�orderItemDB�ж�Ӧ�˵���
        quint16 num = queryOrderItem.value(3).toInt();    //colume 3 �ڱ�orderItemDB�ж�Ӧĳ���˵�����
        float  price = queryOrderItem.value(2).toFloat();
        totalPrice += price * num;
        m_html += "<tr><td align=\"center\">" + name + "</td><td align=\"center\">" + QString::number(price, 'g', 6)
                + "</td><td align=\"center\">"+QString::number(num)+ "</td><td align=\"center\">"+QString::number(price*num, 'g', 6)+"</td></tr>";
    }
    m_html += "</table>";
    m_html += "<hr  width=\"90%\" size=\"15\">";
    m_html += "<div align=\"center\">" + QObject::tr("�ܼ�: ")
               + "<font size=\"+2\">" + QString::number(totalPrice, 'g', 6)  + "</font>&nbsp;"
               + QObject::tr("�ۿ�: ") + "<font size=\"+1\">" + QString::number(discount, 'g', 6) +"</font>&nbsp;"
            + QObject::tr("Ӧ��: ") + "<font size=\"+1\">" + renderMoney + "</font></div>";
    m_html += "<div align=\"center\">" + QObject::tr("ʵ��: ")
               + "<font size=\"+2\">" + giveMoney  +"</font>&nbsp;"
            + QObject::tr("����: ") + "<font size=\"+1\">" +  changeMoney + "</font></div>";

    m_html += "<p align=\"center\">" + QObject::tr("*���׻�ӭ���ٴι���*") + "</p>";
    m_html +="<div align=\"center\">" + QObject::tr("�������ߣ�&nbsp;88888888") + "</div>";

    //debug: to get available printer in local area
    QString m_printers = printerList();
    qDebug(m_printers.toUtf8());

    //find the wanted network printer to print
    QPrinterInfo printerInfo = QPrinterInfo();
    QPrinterInfo targetPrinterInfo = QPrinterInfo();

    foreach(QPrinterInfo item, printerInfo.availablePrinters()){
        if(item.printerName() == QString::fromStdString("GP-H80250 Series")){
            //m_printer = new QPrinter(item, QPrinter::HighResolution);
            targetPrinterInfo = item;
            qDebug(targetPrinterInfo.printerName().toUtf8());
            break;
        }else{
            qDebug("nothing!!!");
        }
    }

    QPrinter m_printer(targetPrinterInfo, QPrinter::HighResolution);
    //QPrinter  m_printer(QPrinter::HighResolution);

    //m_printer.setOutputFormat(QPrinter::NativeFormat);
    //m_printer.setOutputFileName("/home/ljl/Kitchen1.pdf");

    QTextDocument m_textDocument;
    m_textDocument.setHtml(m_html); //QTextDocument::setPlainText(const QString &text)
    m_textDocument.setPageSize(QSizeF(m_printer.logicalDpiX()*(30/25.4),
                                  m_printer.logicalDpiY()*(115/25.4)));
    m_textDocument.print(&m_printer);
}

QString Printer::printerList() {
    QString printersName;
    QSqlQuery query;
    query.exec("DROP TABLE printerActualListData");
    query.exec("CREATE TABLE IF NOT EXISTS printerActualListData(printerActualName TEXT)");
    QPrinterInfo printerInfo = QPrinterInfo();
       foreach (QPrinterInfo item, printerInfo.availablePrinters()){
           if( item.printerName() == "Microsoft XPS Document Writer" || item.printerName() == "Fax")
           {}
           else
           {
               query.prepare("INSERT INTO printerActualListData(printerActualName) VALUES(?)");
               query.addBindValue( item.printerName() );
               query.exec();
           }
           printersName.append(item.printerName() + "\n");
       }
    /*   query.prepare("INSERT INTO printerActualListData(printerActualName) VALUES(?)");
       query.addBindValue( "None" );
       query.exec();*/
     return printersName;
}
