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



    void addOrder(const QString &productId,OrderList *orderList);
signals:
    void sqlActionSignal(QVariant type,QVariant obj);

public slots:
    void sqlActionSlot(QVariant type,QVariant obj);
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
