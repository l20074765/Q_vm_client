#ifndef SQLCOLUMN_H
#define SQLCOLUMN_H

#include <QObject>

class SqlColumn : public QObject
{
    Q_OBJECT
    Q_PROPERTY(quint32 id READ getId WRITE setId)
    Q_PROPERTY(quint32 bin READ getBin WRITE setBin)
    Q_PROPERTY(quint32 column READ getColumn WRITE setColumn)
    Q_PROPERTY(quint32 state READ getState WRITE setState)
    Q_PROPERTY(quint32 remain READ getRemain WRITE setRemain)
    Q_PROPERTY(quint32 total READ getCapacity WRITE setCapacity)
    Q_PROPERTY(QString productNo READ getProductNo WRITE setProductNo)

public:
    explicit SqlColumn(QObject *parent = 0);
    ~SqlColumn();


    quint32 getId(){return id;}
    void setId(int id){this->id = id;}


    quint32 getBin(){return bin;}
    void setBin(int bin){this->bin = bin;}

    quint32 getColumn(){return column;}
    void setColumn(int column){this->column = column;}

    quint32 getState(){return state;}
    void setState(int state){this->state = state;}

    quint32 getRemain(){return remain;}
    void setRemain(int remain){this->remain = remain;}

    quint32 getCapacity(){return capacity;}
    void setCapacity(int capacity){this->capacity = capacity;}

    QString getProductNo(){return productNo;}
    void setProductNo(const QString &productNo){this->productNo = productNo;}


    quint32 id;
    quint32 bin;
    quint32 state;
    quint32 column;
    QString productNo;
    QString message;
    quint32 remain;//余量
    quint32 capacity;//容量
    quint8  result;//出货结果

signals:

public slots:
};

#endif // SQLCOLUMN_H
