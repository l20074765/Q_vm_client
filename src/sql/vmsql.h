#ifndef VMSQL_H
#define VMSQL_H
#include <QObject>
#include <QThread>
#include <QSqlDatabase>
#include <QSqlTableModel>
#include <QHash>


#include "productobject.h"


class VmSql : public QThread
{
    Q_OBJECT
public:
    explicit VmSql(QThread *parent = 0);
    ~VmSql();


    void stopThread();
    void startThread();

    bool sqlConnection();

    inline bool isSqlConnected(){return this->sqlConnected;}

    void productTableCheck();

    QHash<QString,ProductObject *> &getProductHash(){return (productHash);}

    enum{
        SQL_CONNECT_FAIL = 0,
        SQL_CONNECT_OK
    };





signals:
    void sqlRptSignal(quint32 type);
    void sqlProductChanged();
    void sqlAddProduct(ProductObject * obj);
protected:
    virtual void run();

public slots:
    void tabelModelInit();
    void sqlRptSlot(quint32 type);
private:
    bool stopped;
    bool sqlConnected;
    QSqlDatabase m_db;
    QSqlTableModel *m_model;
    QSqlTableModel *m_modelCabinet;
    QList<QSqlTableModel *> m_modelCabinetList;
    QHash<QString,ProductObject *> productHash;
};

#endif // VMSQL_H
