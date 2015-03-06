#ifndef VMSQL_H
#define VMSQL_H
#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlTableModel>

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

    enum{
        SQL_CONNECT_FAIL = 0,
        SQL_CONNECT_OK,
        SQL_PRODUCT_ADD,
        SQL_PRODUCT_DEC,
        SQL_START,
        SQL_GOODS_SELECT
    };

    ProductObject *sqlFindProduct(const QString &product_id);


signals:
    void sqlActionSignal(int type,QObject *obj);
protected:

public slots:
    void sqlActionSlot(int type,QObject *obj);
    void tabelModelInit();
private:
    void sql_start();
private:
    bool sqlConnected;
    QSqlDatabase m_db;
    QSqlTableModel *m_model;
    QSqlTableModel *m_modelCabinet;
    QList<QSqlTableModel *> m_modelCabinetList;


};

#endif // VMSQL_H
