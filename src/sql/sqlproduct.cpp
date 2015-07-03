#include "sqlproduct.h"
#include <QtDebug>
SqlProduct::SqlProduct(QObject *parent) : QObject(parent)
{
    id = "";
    name = "";
    salePrice = 100;
    buyNum = 0;
    image = "../../images/product/default_product.png";
    imagePath = "../../images/productImage/";
}

SqlProduct::~SqlProduct()
{

}


void SqlProduct::setSalePriceStr(const QString &text)
{
    bool ok;
    quint32 temp = text.toUInt(&ok,10);
    if(ok){
        salePrice = temp;
    }
    else{
        salePrice = 0;
    }
}

QString SqlProduct::getSalePriceStr()
{
    QString str = QString("%1.%2")
            .arg(salePrice/100)
            .arg(salePrice%100,2,10,QLatin1Char('0'));
    return str;

}





