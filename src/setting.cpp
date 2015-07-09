#include "setting.h"
#include <QSettings>
#include <QDir>
#include <QtDebug>
#include <QFile>
#include <QFileInfo>

Setting vmConfig;


Setting::Setting(QObject *parent) : QObject(parent)
{
    QSettings *read = new QSettings("config.ini",QSettings::IniFormat);
    bool ok;
    qmlDebug = read->value("CONFIG/QmlDebug").toInt(&ok);
    vmPort = read->value("CONFIG/VmPort").toString();
    if(vmPort.isEmpty())
        vmPort = "COM1";
    delete read;
}

Setting::~Setting()
{

}


QString Setting::productDefaultPic()
{
    return "../../images/product/default_product.png";
}

QString Setting::productPicPath() //用户放置图片的文件夹
{
    return "../../images/productPic";
}

QString Setting::productImagePath()
{
    return "../../images/productImage";
}




bool Setting::createDir(const QString &filePath)
{
     QDir dir(filePath);
     if(!dir.exists()){ //目录不存在则创建
        bool ok = dir.current().mkdir(filePath);
        if(!ok){
            return false;
        }
        else{
           return true;
        }
     }
     else{
         return true;
     }
}

QStringList Setting::getFilePicList(const QString &filePath)
{
    QStringList list;
    QDir dir(filePath);

    if(!dir.exists()){ //目录不存在则创建
       bool ok = dir.current().mkdir(filePath);
       if(!ok){
           //qDebug()<<"getFilePicList"<<"创建目录失败!"<<filePath;
           return list;
       }
       else{
           //qDebug()<<"getFilePicList"<<"创建目录成功!"<<filePath;
           dir.setPath(filePath);

       }
    }

    QStringList filter;
    filter<<"*.jpg"<<"*.png";
    list = dir.entryList(filter);
   // qDebug()<<"getFileList"<<list;
    if(list.isEmpty()){
        return list;
    }
    else{
        return list;
    }

}
