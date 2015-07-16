#include "sqlcabinetlist.h"
#include <QtDebug>

SqlCabinetList::SqlCabinetList(QObject *parent) : QObject(parent)
{
    list.clear();
}

SqlCabinetList::~SqlCabinetList()
{
    clear();
}

void SqlCabinetList::clear()
{
    for(int i = 0;i < list.size();i++){
        SqlCabinet *cabinet = list.at(i);
        delete cabinet;
    }
    list.clear();
}


bool SqlCabinetList::remove(int no)
{
    for(int i = 0;i < list.size();i++){
        SqlCabinet *cabinet = list.at(i);
        if(cabinet->id == no){
            list.removeAt(i);
            delete cabinet;
        }
    }
    return true;
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
