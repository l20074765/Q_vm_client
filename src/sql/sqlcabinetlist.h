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

    void getCount(){return this->list.count();}


signals:

public slots:
    SqlCabinet *at(int i){return this->list.at(i);}
    bool append(SqlCabinet *cabinet){return this->list.append(cabinet);}

private:
    QList<SqlCabinet *> list;
};

#endif // SQLCABINETLIST_H
