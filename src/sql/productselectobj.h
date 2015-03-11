#ifndef PRODUCTSELECTOBJ_H
#define PRODUCTSELECTOBJ_H

#include <QObject>

class ProductSelectObj : public QObject
{
    Q_OBJECT
public:
    explicit ProductSelectObj(QObject *parent = 0);
    ~ProductSelectObj();


    QString id;
    QString name;
    quint32 salePrice;
    quint32 buyNum;//购买数量
signals:

public slots:

};

#endif // PRODUCTSELECTOBJ_H
