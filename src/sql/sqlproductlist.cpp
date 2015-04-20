#include "sqlproductlist.h"
#include <QtDebug>
#include <QThread>
SqlProductList::SqlProductList(QObject *parent) : QObject(parent)
{
    list.clear();
    hash.clear();
}

SqlProductList::~SqlProductList()
{

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






