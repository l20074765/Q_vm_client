#include "sqlproductlist.h"
#include <QtDebug>
#include <QThread>
#include <QFile>
#include <QDir>

#include "setting.h"

SqlProductList::SqlProductList(QObject *parent) : QObject(parent)
{
    list.clear();
    hash.clear();
}

SqlProductList::~SqlProductList()
{

}


bool SqlProductList::updateProductImage(SqlProduct *p)
{
    //矫正图片
    QString pic = p->pic;
    if(pic.startsWith("file:///")){
        qDebug()<<"picFile.startsWith = true";
        pic.remove(0,8);
    }
    QFileInfo fileInfo(pic);
    QString picName = fileInfo.fileName();
   //QString picPath = fileInfo.absolutePath();
    QString imagePath = vmConfig.productImagePath() + "/" + p->id;
    bool ok = vmConfig.createDir(imagePath);

    if(ok){
        QString newFileName = imagePath + "/" + picName;
        QFile newFile(newFileName);
        if(newFile.exists()){
            newFile.remove();
        }
        bool okk = QFile::copy(pic,newFileName);
        qDebug()<<"vmInsertProduct:copy="<<okk;
        p->imagePath = imagePath;
        p->images = vmConfig.getFilePicList(imagePath);
        if(p->images.isEmpty()){
            p->pic = vmConfig.productDefaultPic();
        }
        else{
            p->pic = p->imagePath + "/" + p->images.at(0);
        }
        return true;
    }
    else{
        return false;
    }
}


bool SqlProductList::isContains(const QString &key)
{
    qDebug()<<"SqlProductList-isContains"<<key;
    if(hash.contains(key)){
        return true;
    }
    else{
        return false;
    }
}

SqlProduct *SqlProductList::get(const QString &key)
{
   return hash.value(key);
}

SqlProduct *SqlProductList::add(const QString &key)
{
    if(hash.contains(key)){
        return NULL;
    }
    else{
        SqlProduct *product = new SqlProduct(0);
        if(product == NULL) {
            qDebug()<<"SqlProductList-add"<<"product == NULL";
            return NULL;
        }
        else{
            this->hash.insert(key,product);
            return product;
        }
    }
}

void SqlProductList::hashInsert(const QString &key,SqlProduct *obj)
{
    this->hash.insert(key,obj);

}


SqlProduct *SqlProductList::hashValue(const QString &key)
{
    SqlProduct *p = hash.value(key);
    return p;
}


void SqlProductList::getProductList()
{
    list.clear();
    list = hash.values();
}



bool SqlProductList::remove(const QString &key)
{
    SqlProduct *p = hash.value(key);
    if(p == NULL){
        return false;
    }
    else{
        hash.remove(key);
        delete p;
        qDebug()<<"删除Hash链表剩余:count="<<hash.count();
        return true;
    }
}





