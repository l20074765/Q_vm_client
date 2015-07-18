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
    ~SqlCabinetList();


    quint32 getCount(){return this->list.count();}


signals:

public slots:
    SqlCabinet *at(int i){return this->list.at(i);}
    SqlCabinet *get(int no);
    SqlCabinet *create(int no);
    SqlColumn *getColumn(int id);
    bool remove(int no);
    void append(SqlCabinet *cabinet){this->list.append(cabinet);}
    int count(){return this->list.count();}
    void clear();
private:
    QList<SqlCabinet *> list;
};

#endif // SQLCABINETLIST_H
