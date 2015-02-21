#ifndef PRODUCTOBJECT_H
#define PRODUCTOBJECT_H

#include <QObject>
#include <QMetaType>



class ProductObject: public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ getId WRITE setId NOTIFY idChanged)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString salePrice READ getSalePrice WRITE setSalePrice)
public:



    explicit ProductObject(QObject *parent = 0);
    ~ProductObject();


    QString getId(){return id;}
    void setId(const QString &id){this->id = id;}


    QString getName(){return name;}
    void setName(const QString &name){this->name = name;}


    QString getSalePrice(){return salePrice;}
    void setSalePrice(const QString &salePrice){this->salePrice = salePrice;}


    QString id;
    QString name;
    QString salePrice;


signals:
    void idChanged();
public slots:

private:   

};





#endif // PRODUCTOBJECT_H
