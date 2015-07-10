#ifndef SQLCOLUMNLIST_H
#define SQLCOLUMNLIST_H

#include <QObject>
#include "sqlcolumn.h"

#include <QQueue>
#include <QHash>
#include <QMultiHash>
#include <QList>
class SqlColumnList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int size READ size)
public:
    explicit SqlColumnList(QObject *parent = 0);
    ~SqlColumnList();

    int size(){return this->list.count();}

    QList<SqlColumn *> list;
    QHash<quint32,SqlColumn *> hash;
    QMultiHash<QString,SqlColumn *> multiHash;
signals:

public slots:
    SqlColumn *at(int i){return this->list.at(i);}
    void append(SqlColumn *column){this->list.append(column);}

private:

};

#endif // SQLCOLUMNLIST_H
