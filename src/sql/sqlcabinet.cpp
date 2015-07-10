#include "sqlcabinet.h"

SqlCabinet::SqlCabinet(QObject *parent) : QObject(parent)
{
    columnList = new SqlColumnList(this);
}

