#ifndef SQLCOLUMN_H
#define SQLCOLUMN_H

#include <QObject>

class SqlColumn : public QObject
{
    Q_OBJECT
    Q_PROPERTY(quint32 id READ getId)
    Q_PROPERTY(quint32 bin READ getBin)
    Q_PROPERTY(quint32 column READ getColumn)
    Q_PROPERTY(quint32 state READ getState)
    Q_PROPERTY(QString productNo READ getProductNo)
public:
    explicit SqlColumn(QObject *parent = 0);
    ~SqlColumn();


    quint32 getId(){return id;}
    quint32 getBin(){return bin;}
    quint32 getColumn(){return column;}
    quint32 getState(){return state;}
    QString getProductNo(){return productNo;}


    quint32 id;
    quint32 bin;
    quint32 state;
    quint32 column;
    QString productNo;
    quint32 remain;//余量
    quint32 capacity;//容量
    quint8  result;//出货结果

signals:

public slots:
};

#endif // SQLCOLUMN_H
