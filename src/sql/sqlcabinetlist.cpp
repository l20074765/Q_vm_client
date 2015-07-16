#include "sqlcabinetlist.h"
#include <QtDebug>

SqlCabinetList::SqlCabinetList(QObject *parent) : QObject(parent)
{
    list.clear();
}



SqlCabinet *SqlCabinetList::get(int no)
{
    for(int i = 0;i < list.count();i++){
        SqlCabinet *cab = list.at(i);
        if(cab->id == (quint32)no){
            return cab;
        }
    }
    return NULL;
}

SqlCabinet *SqlCabinetList::create(int no)
{
    qDebug()<<"C++:创建货柜:no = "<<no;
    if(no == 0){
        return NULL;
    }
    for(int i = 0;i < list.count();i++){
        SqlCabinet *cab = list.at(i);
        if(cab->id == (quint32)no){
            qDebug()<<"C++:货柜编号重复 no="<<no;
            return NULL;
        }
    }

    SqlCabinet *cabinet = new SqlCabinet(0);
    if(cabinet){
        cabinet->id = no;
        list.append(cabinet);
        return cabinet;
    }
    else{
        qDebug()<<"C++:创建货柜失败";
        return NULL;
    }

}
