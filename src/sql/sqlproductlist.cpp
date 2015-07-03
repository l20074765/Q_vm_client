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






