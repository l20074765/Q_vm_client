#include "vmorderobj.h"

VmOrderObj::VmOrderObj(QObject *parent) : QObject(parent)
{

    this->buyNum = 0;
    this->salePrice = 0;
    this->id  ="";

}

VmOrderObj::~VmOrderObj()
{

}

QString VmOrderObj::getSalePriceStr()
{
    QString str = QString("%1.%2")
            .arg(salePrice/100)
            .arg(salePrice%100,2,10,QLatin1Char('0'));
    return str;

}
