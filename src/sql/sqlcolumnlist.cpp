#include "sqlcolumnlist.h"

SqlColumnList::SqlColumnList(QObject *parent) : QObject(parent)
{

    list.clear();
}

SqlColumnList::~SqlColumnList()
{
    clear();
}


bool SqlColumnList::remove(int col)
{
    for(int i = 0;i < list.size();i++){
        SqlColumn *column = list.at(i);
        if(column->column == col){
            list.removeAt(i);
            delete column;
        }
    }
    return true;
}



void SqlColumnList::clear()
{
    for(int i = 0;i < list.size();i++){
        SqlColumn *column = list.at(i);
        delete column;
    }
    list.clear();
}
