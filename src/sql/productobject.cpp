#include "productobject.h"

ProductObject::ProductObject(QObject *parent)
    :QObject(parent)
{
    id = "";
    name = "";
    salePrice = 100;
}



ProductObject::~ProductObject()
{

}

