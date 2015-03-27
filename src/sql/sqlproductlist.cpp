#include "sqlproductlist.h"

SqlProductList::SqlProductList(QObject *parent) : QObject(parent)
{
    queue.clear();
    hash.clear();
}

SqlProductList::~SqlProductList()
{
    QHash<QString,SqlProduct *>::const_iterator i;
    for(i =hash.constBegin();i != hash.constEnd();i++){
        SqlProduct *p = i.value();
        if(p){
            delete p;
        }
    }
    hash.clear();

}



