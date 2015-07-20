#ifndef VMSQLITE_H
#define VMSQLITE_H

#include <QObject>
#include <QtSql>
#include <QVariant>
#include "sqlproductlist.h"
#include "sqlcolumnlist.h"
#include "orderlist.h"
#include "sqlcabinetlist.h"
#include "vmcmainflow.h"


class VMSqlite : public QObject
{
    Q_OBJECT
    Q_ENUMS(SqlEnumType)
public:
    explicit VMSqlite(QObject *parent = 0);
    ~VMSqlite();

    enum SqlEnumType{
        SQL_CONNECT_FAIL = 0,
        SQL_CONNECT_OK,
        SQL_PRODUCT_ADD,
        SQL_PRODUCT_DEC,
        SQL_START,
        SQL_GOODS_SELECT,
        SQL_COLUMN_ADD,
        SQL_CABINET_CHECK_FINISH,
        SQL_COLUMN_CHECK,
        SQL_ORDER_MAKE
    };

    bool openSqlDatabase(const QString& fileName);
    bool tableAvailable(const QString &tableName);
    bool createTableCabinet();
    bool createTableColumn();
    bool createTableProduct();
    bool insertProduct(const SqlProduct *product);
    bool updateProduct(const SqlProduct *product);
    bool deleteProduct(const QString &productNo);


    bool insertCabinet(const SqlCabinet *cabinet);
    bool updateCabinet(const SqlCabinet *cabinet);
    bool deleteCabinet(const SqlCabinet *cabinet);


    bool insertColumn(const SqlColumn *column);
    bool updateColumn(const SqlColumn *column);
    bool deleteColumn(const SqlColumn *column);
    bool deleteColumnByCabinet(const int no);


    bool vmDeleteProduct(const QString &productId);
    bool vmUpdateProduct(const QString &productId);
    bool vmInsertProduct(const QString &productId);


    bool vmCreateCabinet(const int no);
    bool vmDeleteCabinet(const int no);


    bool vmUpdateColumn(const int id);


    SqlProductList *getSqlProductList(){return this->productList;}
    SqlCabinetList *getSqlCabinetList(){return this->cabinetList;}
    OrderList *getOrderList(){return this->orderList;}
signals:
    void sqlActionSignal(int type,QObject *obj);

public slots:
    void sqlActionSlot(int type,QObject * obj);
    void addOrder(const QString &productId);
private:
    QSqlDatabase m_db;
    bool sqlConnected;

    void sqlStart();
    void checkTableProduct();
    void checkTableCabinet();

    SqlProductList *productList;
    SqlCabinetList *cabinetList;

    OrderList *orderList;//订单管理类
};


#endif // VMSQLITE_H
