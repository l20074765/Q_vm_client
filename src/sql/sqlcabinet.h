#ifndef SQLCABINET_H
#define SQLCABINET_H

#include <QObject>
#include "sqlcolumnlist.h"



class SqlCabinet : public QObject
{
    Q_OBJECT
    Q_PROPERTY(quint32 id READ getId WRITE setId)
    Q_PROPERTY(quint32 sum READ getSum WRITE setSum)
public:
    explicit SqlCabinet(QObject *parent = 0);

    quint32 getId(){return this->id;}
    void setId(quint32 id){this->id = id;}

    quint32 getSum(){return this->sum;}
    void setSum(quint32 sum){this->sum = sum;}





    quint32 id;
    quint32 sum;
    quint8  type;
    QString info;
    SqlColumnList *columnList;
signals:

public slots:
    SqlColumnList *getColumnList(){return this->columnList;}

};

#endif // SQLCABINET_H
