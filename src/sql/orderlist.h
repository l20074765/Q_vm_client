#ifndef ORDERLIST_H
#define ORDERLIST_H

#include <QObject>
#include "order.h"
#include <QList>

class OrderList : public QObject
{
    Q_OBJECT
    //Q_PROPERTY(int size READ size)
public:
    explicit OrderList(QObject *parent = 0);
    ~OrderList();

    QList<Order *> list;
signals:

public slots:


private:


};

#endif // ORDERLIST_H
