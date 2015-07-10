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

//默认商品图片路径
QString Setting::productDefaultPic()
{
    return "E:/work/QT/EV/Q_vm_client/images/product/default_product.png";
}

//用户放置图片的文件夹路径
QString Setting::productPicPath()
{
    return "E:/work/QT/EV/Q_vm_client/images/productPic";
}

//商品图片保存路径
QString Setting::productImagePath()
{
    return "E:/work/QT/EV/Q_vm_client/images/productImage";
}


//QML路径包头
QString Setting::qmlPath()
{
    return "file:///";
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


bool Setting::deleteDir(const QString &path)
{
    if(path.isEmpty())
       return false;

    QDir dir(path);
    if(!dir.exists())
       return true;
    dir.setFilter(QDir::AllEntries | QDir::NoDotAndDotDot);
    QFileInfoList infoList = dir.entryInfoList();
    foreach (QFileInfo in, infoList) {
       if(in.isFile()){
           in.dir().remove(in.fileName());
       }
       else{
           deleteDir(in.absoluteFilePath());
       }
    }

    return dir.rmdir(dir.absolutePath());
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
