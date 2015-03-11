#ifndef COLUMNMANAGE_H
#define COLUMNMANAGE_H

#include <QObject>
#include <QHash>
#include <QStringList>

#include "columnobject.h"
class ColumnManage : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int cabinetCount READ getCabinetCount)
    Q_PROPERTY(quint32 columnCount READ getColumnCount)
public:
    explicit ColumnManage(QObject *parent = 0);
    ~ColumnManage();

    int getCabinetCount(){return cabinetList.count();}
    quint32 getColumnCount(){return (quint32)this->columnList.count();}

    void addColumn(const ColumnObject *obj);


signals:

public slots:

    ColumnObject *getColumnObjByIndex(int index);
private:
    QHash<quint32,ColumnObject *> columnHash;
    QList<quint32>columnList;
    QList<quint32>cabinetList;


};

#endif // COLUMNMANAGE_H
