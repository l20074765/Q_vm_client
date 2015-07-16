#ifndef SQLCABINETLIST_H
#define SQLCABINETLIST_H
#include "sqlcabinet.h"
#include <QList>


class SqlCabinetList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int count READ getCount)
public:
    explicit SqlCabinetList(QObject *parent = 0);

    quint32 getCount(){return this->list.count();}


signals:

public slots:
    SqlCabinet *at(int i){return this->list.at(i);}
    SqlCabinet *get(int no);
    SqlCabinet *create(int no);
    void append(SqlCabinet *cabinet){this->list.append(cabinet);}
    quint32 count(){return this->list.count();}
private:
    QList<SqlCabinet *> list;
};

#endif // SQLCABINETLIST_H
