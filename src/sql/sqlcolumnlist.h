#ifndef SQLCOLUMNLIST_H
#define SQLCOLUMNLIST_H

#include <QObject>
#include "sqlcolumn.h"

#include <QQueue>
#include <QHash>
#include <QMultiHash>
class SqlColumnList : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int size READ size)
public:
    explicit SqlColumnList(QObject *parent = 0);
    ~SqlColumnList();

    int size(){return this->queue.size();}
    void append(SqlColumn *obj){this->queue<<obj;}



    QHash<quint32,SqlColumn *> hash;
    QQueue<SqlColumn *> queue;
    QMultiHash<QString,SqlColumn *> multiHash;
signals:

public slots:
    SqlColumn *at(int i){return this->queue.at(i);}
    void queueClear(){this->queue.clear();}
private:

};

#endif // SQLCOLUMNLIST_H
