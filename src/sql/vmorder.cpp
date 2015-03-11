#include "vmorder.h"
#include <QtDebug>
VmOrder::VmOrder(QObject *parent) : QObject(parent)
{

}

VmOrder::~VmOrder()
{

}


VmOrderObj *VmOrder::getOrderObjByIndex(quint32 index)
{
    if(index >= this->orderList.count())
        return NULL;
    return this->orderList.at(index);
}

void VmOrder::clearOrderList()
{
    for(int i = 0; i < orderList.count();i++){
        VmOrderObj *obj = orderList.at(i);
        if(obj){
            for(int j = 0; j <  obj->columnList.count();j++){
                ColumnObject * column =   obj->columnList.at(j);
                if(column){
                    delete column;
                }
            }
        }
        delete obj;
    }
    orderList.clear();

}


void VmOrder::addOrderList(VmOrderObj *obj)
{
    orderList<<obj;
}



bool VmOrder::hasOrder(const QString &id)
{

    for(int i =0;i < orderList.count();i++){
        VmOrderObj *obj = orderList.at(i);
        qDebug()<<"hasOrder obj->id"<<obj->id;
        if(obj->id == id){
            return true;
        }
    }
    return false;
}

void VmOrder::addOrderBuyNum(const QString &id)
{
    for(int i =0;i < orderList.count();i++){
        VmOrderObj *obj = orderList.at(i);
        if(obj->id == id){
            obj->buyNum++;
            return;
        }
    }
}

void VmOrder::addOrder(const QString &id)
{


}


