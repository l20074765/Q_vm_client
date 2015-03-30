#ifndef SQLPRODUCTLIST_H
#define SQLPRODUCTLIST_H

#include <QObject>
#include "sqlproduct.h"
#include <QHash>
#include <QQueue>

class SqlProductList : public QObject
{
    Q_OBJECT

    Q_PROPERTY(int size READ size)
public:
    explicit SqlProductList(QObject *parent = 0);
    ~SqlProductList();

    int size(){return this->queue.size();}
    void append(SqlProduct *obj){this->queue<<obj;}


    void hashInsert(const QString &key,SqlProduct *obj);
    SqlProduct *hashValue(const QString &key);



    QQueue<SqlProduct *> queue;//商品列表缓冲区

signals:

public slots:
    SqlProduct *at(int i){return this->queue.at(i);}
    void queueClear();
private:

    QHash<QString,SqlProduct *> hash;

};



//Q_DECLARE_METATYPE(SqlProductList);

#endif // SQLPRODUCTLIST_H
