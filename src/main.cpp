#include<QTextCodec>
#include "mainwindow.h"
#include <QtDebug>
#include <QDir>
#include<QApplication>
#include <stdio.h>
#include <stdlib.h>
#include "custom.h"

QtMsgHandler systemMsgOutput = 0;
//日志定位输出
void myMessageOutput(QtMsgType type, const char *msg)
{
    //QString strMsg = QString::fromUtf8(msg);
    if(systemMsgOutput)
        systemMsgOutput(type, msg);

}



int main(int argc,char *argv[])
{
    systemMsgOutput = qInstallMsgHandler(myMessageOutput);

    QApplication app(argc,argv);


    app.setApplicationName(QObject::trUtf8("QVMClient"));
    app.setApplicationVersion(QObject::trUtf8("1.1.0"));
    app.setApplicationName(QObject::trUtf8("QVMClient"));
    app.setOrganizationName(QObject::trUtf8("easivend"));


    qDebug()<<QObject::trUtf8("测试日志输出")<<QT_VERSION_STR
           <<qApp->applicationVersion();


    QTextCodec::setCodecForLocale(QTextCodec::codecForName("UTF-8"));
    QTextCodec::setCodecForCStrings(QTextCodec::codecForName("UTF-8"));



    MainWindow window;
    window.show();
    return app.exec();
}

