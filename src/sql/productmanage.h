#ifndef PRODUCTMANAGE_H
#define PRODUCTMANAGE_H

#include <QObject>
#include <QHash>
#include <QStringList>
#include "productobject.h"


class ProductManage : public QObject
{
    Q_OBJECT
    Q_PROPERTY(quint32 productCount READ getProductCount)
public:
    explicit ProductManage(QObject *parent = 0);
    ~ProductManage();

    typedef QHash<QString,ProductObject *> TYPE_ProductHash;
    quint32 getProductCount(){return this->productList.count();}

    void addProduct(const ProductObject *obj);
    void destroyProduct();

    ProductObject *getProductObjByHash(const QString &key);

signals:

public slots:
    ProductObject *getAddProductObj();
    ProductObject *getProductObjByIndex(int index);
private:
    QHash<QString,ProductObject *> productHash;
    QStringList productList;
    QList<ProductObject *> productCacheList;


};

#endif // PRODUCTMANAGE_H
