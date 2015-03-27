#ifndef ORDER_H
#define ORDER_H

#include <QObject>
#include "sqlcolumn.h"
class Order : public QObject
{
    Q_OBJECT
public:
    explicit Order(QObject *parent = 0);
    ~Order();


    QString getSalePriceStr();

    QString id;//商品ID
    QString name;//商品名称
    quint32 salePrice;//销售价
    quint32 buyNum;//购买数量
    QList<SqlColumn *> columnList;//该商品绑定的所有货道号
    quint8 tradeRst;//该商品绑定的货道出货结果
signals:

public slots:
};

#endif // ORDER_H
