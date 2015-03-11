#include "columnmanage.h"

ColumnManage::ColumnManage(QObject *parent) : QObject(parent)
{
    columnHash.clear();
    columnList.clear();
}

ColumnManage::~ColumnManage()
{

}



void ColumnManage::addColumn(const ColumnObject *obj)
{
    ColumnObject *column = (ColumnObject *)obj;
    columnList<<column->id;
    columnHash.insert(column->id,column);

}

ColumnObject *ColumnManage::getColumnObjByIndex(int index)
{
    if(index >= columnList.count())
        return NULL;
    quint32 id = columnList.at(index);
    return columnHash.value(id);
}
