#ifndef PRODUCTOBJECT_H
#define PRODUCTOBJECT_H

#include <QObject>
#include <QMetaType>



class ProductObject: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ getId WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString salePriceStr READ getSalePriceStr)
    Q_PROPERTY(quint32 salePrice READ getSalePrice WRITE setSalePrice)
public:
    explicit ProductObject(QObject *parent = 0);
    ~ProductObject();

    QString getId(){return id;}
    void setId(const QString &id){this->id = id;}

    QString getName(){return name;}
    void setName(const QString &name){this->name = name;}

    QString getSalePriceStr();

    quint32 getSalePrice(){return salePrice;}
    void setSalePrice(const quint32 &salePrice){this->salePrice = salePrice;}

    QString id;
    QString name;
    quint32 salePrice;
    quint32 buyNum;//购买数量

signals:
    void idChanged();
public slots:

private:


};





#endif // PRODUCTOBJECT_H
