#ifndef SQLPRODUCTLIST_H
#define SQLPRODUCTLIST_H

#include <QObject>
#include "sqlproduct.h"
#include <QHash>


class SqlProductList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int size READ size)
public:
    explicit SqlProductList(QObject *parent = 0);
    ~SqlProductList();

    int size(){return this->list.size();}

    void hashInsert(const QString &key,SqlProduct *obj);
    SqlProduct *hashValue(const QString &key);

    void getProductList();
signals:

public slots:
    SqlProduct *at(int i){return this->list.at(i);}
    SqlProduct *add(const QString &key);
    SqlProduct *get(const QString &key);
    bool remove(const QString &key);
    bool       isContains(const QString &key);
    bool    updateProductImage(SqlProduct *p);
private:

    QHash<QString,SqlProduct *> hash;
    QList<SqlProduct *> list;

};



//Q_DECLARE_METATYPE(SqlProductList);

#endif // SQLPRODUCTLIST_H
