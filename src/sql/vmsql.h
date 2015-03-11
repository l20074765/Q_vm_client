#ifndef VMSQL_H
#define VMSQL_H
#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include "productobject.h"
#include "columnobject.h"
#include "vmorderobj.h"

class VmSql : public QObject
{
    Q_OBJECT
public:
    explicit VmSql(QObject *parent = 0);
    ~VmSql();

    bool sqlConnection();
    inline bool isSqlConnected(){return this->sqlConnected;}
    void productTableCheck();
    void columnTableCheck();

    enum{
        SQL_CONNECT_FAIL = 0,
        SQL_CONNECT_OK,
        SQL_PRODUCT_ADD,
        SQL_PRODUCT_DEC,
        SQL_START,
        SQL_GOODS_SELECT,
        SQL_COLUMN_ADD
    };

    ProductObject *sqlFindProduct(const QString &product_id);

    VmOrderObj *sqlFindProductObj(const QString &product_id);

signals:
    void sqlActionSignal(int type,QObject *obj);
protected:

public slots:
    void sqlActionSlot(int type,QObject *obj);
private:
    void sql_start();
private:
    bool sqlConnected;
    QSqlDatabase m_db;

};

#endif // VMSQL_H
