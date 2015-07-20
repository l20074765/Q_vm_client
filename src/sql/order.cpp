#include "order.h"

Order::Order(QObject *parent) : QObject(parent)
{
    this->buyNum = 0;
    this->salePrice = 0;
    this->id  ="";
    priorityColumnId = 0;
}

Order::~Order()
{

}



QString Order::getSalePriceStr()
{
    QString str = QString("%1.%2")
            .arg(salePrice/100)
            .arg(salePrice%100,2,10,QLatin1Char('0'));
    return str;
}
