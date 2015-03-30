#include "sqlproductlist.h"
#include <QtDebug>
#include <QThread>
SqlProductList::SqlProductList(QObject *parent) : QObject(parent)
{


    queue.clear();
    hash.clear();
}

SqlProductList::~SqlProductList()
{

}


void SqlProductList::hashInsert(const QString &key,SqlProduct *obj)
{
    this->hash.insert(key,obj);
   // qDebug()<<"SqlProductList::hashInsert--"<<hash.values();

}


SqlProduct *SqlProductList::hashValue(const QString &key)
{
   // qDebug()<<"qlProductList::hashValue--"<<"key="<<key;
    SqlProduct *p = hash.value(key);

    qDebug()<<"SqlProductList::hashValue---"<<"p="<<p;
    return p;
}


void SqlProductList::queueClear()
{
    this->queue.clear();
   // qDebug()<<"测试Hash表。。。。。";
   // qDebug()<<"SqlProductList::queueClear--"<<hash.values();
}



