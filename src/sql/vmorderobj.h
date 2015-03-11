#ifndef VMORDEROBJ_H
#define VMORDEROBJ_H

#include <QObject>
#include "columnobject.h"


class VmOrderObj : public QObject
{
    Q_OBJECT
public:
    explicit VmOrderObj(QObject *parent = 0);
    ~VmOrderObj();
    QString getSalePriceStr();

    QString id;//商品ID
    QString name;//商品名称
    quint32 salePrice;//销售价
    quint32 buyNum;//购买数量
    QList<ColumnObject *> columnList;//该商品绑定的所有货道号
    quint8 tradeRst;//该商品绑定的货道出货结果

signals:

public slots:
};

#endif // VMORDEROBJ_H
