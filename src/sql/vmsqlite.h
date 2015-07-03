#ifndef VMSQLITE_H
#define VMSQLITE_H

#include <QObject>
#include <QtSql>
#include <QVariant>
#include "sqlproductlist.h"
#include "sqlcolumnlist.h"
#include "orderlist.h"

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
        SQL_COLUMN_CHECK,
        SQL_ORDER_MAKE
    };

    bool openSqlDatabase(const QString& fileName);
    bool tableAvailable(const QString &tableName);
    bool createTableColumn();
    bool createTableProduct();
    bool insertProduct(const SqlProduct *product);
    bool updateProduct(const SqlProduct *product);
    bool deleteProduct(const QString &productNo);
    void addOrder(const QString &productId,OrderList *orderList);

    bool vmInsertProduct(const QString &productId);
    SqlProductList *getSqlProductList(){return this->productList;}
    SqlColumnList *getSqlColumnList(){return this->columnList;}
signals:
    void sqlActionSignal(int type,QObject *obj);

public slots:
    void sqlActionSlot(int type,QObject * obj);
private:
    QSqlDatabase m_db;
    bool sqlConnected;

    void sqlStart();
    void checkTableColumn();
    void checkTableProduct();

    void getProducts(int count, SqlProduct* curProduct, SqlProductList *list);


    SqlProductList *productList;
    SqlColumnList *columnList;
};


#endif // VMSQLITE_H
