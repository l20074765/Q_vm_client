#ifndef SQLPRODUCT_H
#define SQLPRODUCT_H

#include <QObject>
#include  <QStringList>
class SqlProduct : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString id READ getId WRITE setId)
    Q_PROPERTY(QString name READ getName WRITE setName)
    Q_PROPERTY(QString salePriceStr READ getSalePriceStr WRITE setSalePriceStr)
    Q_PROPERTY(QStringList images READ getImages WRITE setImages)
    Q_PROPERTY(QString imagePath READ getImagePath WRITE setImagePath)
    Q_PROPERTY(QString pic READ getPic WRITE setPic)
    Q_PROPERTY(quint32 salePrice READ getSalePrice WRITE setSalePrice)
    Q_PROPERTY(QString kind READ getKind WRITE setKind)

public:
    explicit SqlProduct(QObject *parent = 0);
    ~SqlProduct();

    QString getId(){return id;}
    void setId(const QString &id){this->id = id;}

    QString getName(){return name;}
    void setName(const QString &name){this->name = name;}
    QString getSalePriceStr();
    void setSalePriceStr(const QString &text);

    quint32 getSalePrice(){return salePrice;}
    void setSalePrice(const quint32 &salePrice){this->salePrice = salePrice;}

    QString getImagePath(){return this->imagePath;}
    void setImagePath(const QString &imagePath){this->imagePath = imagePath;}

    QString getPic(){return this->pic;}
    void setPic(const QString &pic){this->pic = pic;}

    QStringList getImages(){return this->images;}
    void setImages(const QStringList &images){this->images = images;}

    QString getKind(){return this->kind;}
    void setKind(const QString &kind){this->kind = kind;}



    QString id;
    QString name;
    quint32 salePrice;
    quint32 buyNum;//购买数量
    QStringList images;
    QString imagePath;
    QString pic;
    QString sellTag;
    QString brandName;
    QString aliasName;
    QString productTXT;
    QString kind;

signals:

public slots:
   // void obj_destroy();


private:


};

#endif // SQLPRODUCT_H
