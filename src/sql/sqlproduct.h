#ifndef SQLPRODUCT_H
#define SQLPRODUCT_H

#include <QObject>

class SqlProduct : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ getId WRITE setId)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString salePriceStr READ getSalePriceStr WRITE setSalePriceStr)
    Q_PROPERTY(QString image READ getImage)
    Q_PROPERTY(quint32 salePrice READ getSalePrice WRITE setSalePrice)
public:
    explicit SqlProduct(QObject *parent = 0);
    ~SqlProduct();

    QString getImage(){return this->image;}

    QString getId(){return id;}
    void setId(const QString &id){this->id = id;}

    QString getName(){return name;}
    void setName(const QString &name){this->name = name;}
    QString getSalePriceStr();
    void setSalePriceStr(const QString &text);

    quint32 getSalePrice(){return salePrice;}
    void setSalePrice(const quint32 &salePrice){this->salePrice = salePrice;}





    QString id;
    QString name;
    quint32 salePrice;
    quint32 buyNum;//购买数量
    QString image;
    QString imagePath;
    QString sellTag;
    QString brandName;
    QString aliasName;
    QString productTXT;

signals:

public slots:
   // void obj_destroy();


};

#endif // SQLPRODUCT_H
