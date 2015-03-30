#include<QTextCodec>
#include <QtDebug>
#include <QDir>
#include<QApplication>
#include <stdio.h>
#include <stdlib.h>
#include <QMutex>
#include "custom.h"
#include "mainview.h"
#include <QDateTime>
QtMsgHandler systemMsgOutput = 0;

//日志定位输出
void myMessageOutput(QtMsgType type, const char *msg)
{
    static QMutex mutex;
    mutex.lock();
    QString text;
    switch(type)
    {
        case QtDebugMsg:
            text = QString("[Debug]");
            break;
        case QtWarningMsg:
            text = QString("[Warn ]");
            break;
        case QtCriticalMsg:
            text = QString("[Crit ]");
            break;
        case QtFatalMsg:
            text = QString("[Fatal]");
        default:
            break;
    }

    QString current_time = QDateTime::currentDateTime()
            .toString("yyyy-MM-dd hh:mm:ss zzz");
    QString message = QString("%1 %2 %3 ")
            .arg(current_time).arg(text).arg(msg);
    QString dateStr = QDateTime::currentDateTime().toString("yyyyMMdd");

    QDir dir;
    if(!dir.exists(QString("log")))
        dir.mkdir("log");
    QString fileName = QString("log/VM_%2.log").arg(dateStr);
    QFile file(fileName);
    file.open(QIODevice::WriteOnly | QIODevice::Append);
    QTextStream text_stream(&file);
    text_stream << message << "\r\n";
    file.flush();
    file.close();
    mutex.unlock();
    if(systemMsgOutput)
        systemMsgOutput(type,msg);
}



int main(int argc,char *argv[])
{
    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForTr(QTextCodec::codecForName("UTF-8"));
    systemMsgOutput = qInstallMsgHandler(myMessageOutput);
    QApplication app(argc,argv);
    app.setApplicationName(QObject::trUtf8("QVMClient"));
    app.setApplicationVersion(QObject::trUtf8("1.1.0"));
    app.setApplicationName(QObject::trUtf8("QVMClient"));
    app.setOrganizationName(QObject::trUtf8("easivend"));
    qDebug()<<QObject::trUtf8("测试日志输出")<<QT_VERSION_STR
           <<qApp->applicationVersion()<<app.applicationDirPath();
    app.addLibraryPath(app.applicationDirPath() + QString("/plugins"));

    MainView view;
    view.show();
    return app.exec();
}

