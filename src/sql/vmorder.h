#ifndef VMORDER_H
#define VMORDER_H

#include <QObject>
#include <QList>
#include "vmorderobj.h"
#include <QMutex>

class VmOrder : public QObject
{
    Q_OBJECT
public:
    explicit VmOrder(QObject *parent = 0);
    ~VmOrder();

    quint32 getOrderCount(){return this->orderList.count();}
    void addOrder(const QString &id);
    void addOrderList(VmOrderObj *);
    VmOrderObj * getOrderObjByIndex(quint32 index = 0);
    void clearOrderList();
    bool hasOrder(const QString &id);
    void addOrderBuyNum(const QString &id);


signals:

public slots:


private:
    QList<VmOrderObj *> orderList;
    QMutex mutex;



};

#endif // VMORDER_H
