#include "sqlcolumnlist.h"

SqlColumnList::SqlColumnList(QObject *parent) : QObject(parent)
{
    hash.clear();
    list.clear();
}

SqlColumnList::~SqlColumnList()
{
    QHash<quint32,SqlColumn *>::const_iterator i;
    for(i = hash.constBegin();i != hash.constEnd();i++){
        SqlColumn *p = i.value();
        if(p){
            delete p;
        }
    }
    hash.clear();
}


