#ifndef SQLCABINET_H
#define SQLCABINET_H

#include <QObject>

class SqlCabinet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QString no READ getNo WRITE setNo)
    Q_PROPERTY(QString sum READ getSum WRITE setSum)
public:
    explicit SqlCabinet(QObject *parent = 0);

    quint32 getNo(){return this->no;}
    void setNo(quint32 no){this->no = no;}

    quint32 getSum(){return this->sum;}
    void setSum(quint32 sum){this->sum = sum;}





    quint32 no;
    quint32 sum;
    quint8  type;
    QString info;
signals:

public slots:
};

#endif // SQLCABINET_H
