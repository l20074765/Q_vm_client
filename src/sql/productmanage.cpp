#include "productmanage.h"
#include <QtDebug>

ProductManage::ProductManage(QObject *parent) : QObject(parent)
{
    productHash.clear();
    productList.clear();
    productCacheList.clear();
}

ProductManage::~ProductManage()
{
   qDebug()<<"ProductManage::~ProductManage";
   //暂时不销毁 但是会出现内存泄露 待解决
   //destroyProduct();
}

void ProductManage::destroyProduct()
{
    QHash<QString,ProductObject *>::const_iterator i;
    //需要销毁对象
    for(i = productHash.begin();i != productHash.end();i++){

        ProductObject *product = i.value();
        qDebug()<<"ProductManage::~ProductManage"<<product<<i.key();
        delete product;
    }
    productHash.clear();
    productList.clear();
    productCacheList.clear();

}


void ProductManage::addProduct(const ProductObject *obj)
{
    ProductObject *product = (ProductObject *)obj;
    productList<<product->id;
    productCacheList<<product;
    productHash.insert(product->id,(ProductObject *)product);
}

ProductObject *ProductManage::getAddProductObj()
{
    if(productCacheList.isEmpty())
        return NULL;
    ProductObject *obj = productCacheList.first(); //添加
    productCacheList.removeFirst();//删除链表
    return obj;
}

ProductObject *ProductManage::getProductObjByIndex(int index)
{
    if(index >= productList.count()) return NULL;
    QString productNo = productList.at(index);
    ProductObject *obj = productHash.value(productNo);
    return obj;


}

ProductObject *ProductManage::getProductObjByHash(const QString &key)
{
    return productHash.value(key);
}



