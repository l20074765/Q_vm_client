#include "sqlproduct.h"
#include <QtDebug>
#include <QList>
#include <QStringList>
#include "setting.h"
#include <QDir>

SqlProduct::SqlProduct(QObject *parent) : QObject(parent)
{
    id = "";
    name = "";
    salePrice = 100;
    buyNum = 0;
    image = "../../images/product/default_product.png";
    imagePath = vmConfig.productImagePath();
}

SqlProduct::~SqlProduct()
{

}



void SqlProduct::setSalePriceStr(const QString &text)
{
    bool ok;
    QString temp = text;
    temp.replace(".","");
    quint32 n = temp.toUInt(&ok,10);
    if(ok){
        salePrice = n;
    }
    else{
        salePrice = 0;
    }

    qDebug()<<"setSalePriceStr:salePrice="<<salePrice;
}

QString SqlProduct::getSalePriceStr()
{
    QString str = QString("%1.%2")
            .arg(salePrice/100)
            .arg(salePrice%100,2,10,QLatin1Char('0'));
    return str;

}








