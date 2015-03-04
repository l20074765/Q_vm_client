#ifndef VMSQL_H
#define VMSQL_H
#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include <QHash>


#include "productobject.h"


class VmSql : public QObject
{
    Q_OBJECT
public:
    explicit VmSql(QObject *parent = 0);
    ~VmSql();

    bool sqlConnection();

    inline bool isSqlConnected(){return this->sqlConnected;}

    void productTableCheck();

    QHash<QString,ProductObject *> &getProductHash(){return (productHash);}

    enum{
        SQL_CONNECT_FAIL = 0,
        SQL_CONNECT_OK
    };
    enum{
        SQL_ACTION_PRODUCT_ADD,
        SQL_ACTION_PRODUCT_DEC
    };
    enum{
        SQL_TYPE_START
    };
    ProductObject *sqlFindProduct(const QString &product_id);


signals:
    void sqlActionSignal(int type,QObject *obj);
protected:

public slots:
    void requestHandle(int type,QObject *obj);
    void tabelModelInit();
    void sqlRptSlot(int type,QObject *obj);


private:
    void sql_start();
private:
    bool sqlConnected;
    QSqlDatabase m_db;
    QSqlTableModel *m_model;
    QSqlTableModel *m_modelCabinet;
    QList<QSqlTableModel *> m_modelCabinetList;
    QHash<QString,ProductObject *> productHash;
};

#endif // VMSQL_H
