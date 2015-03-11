#include "vmsql.h"


#include <QSqlRecord>
#include <QtDebug>
#include <QMetaType>
#include <QSqlQuery>
#include <QtDebug>

VmSql::VmSql(QObject *parent) : QObject(parent)
{
    sqlConnected = false;
}

VmSql::~VmSql()
{

}




//启动数据库
void VmSql::sqlActionSlot(int type,QObject *obj)
{
    qDebug()<<trUtf8("数据库线程操作")<<"type="<<type<<obj
           <<QThread::currentThread();
    if(type == SQL_START)
    {
        sql_start();
    }
    else if(type == SQL_GOODS_SELECT)
    {
        ProductObject *reqPro = qobject_cast<ProductObject *>(obj);
        if(reqPro)
        {
            QString id = reqPro->id;
            ProductObject *product = sqlFindProduct(id);
            emit sqlActionSignal(SQL_GOODS_SELECT,product);
            //主动销毁reqPro对象
            qDebug()<<"Delete reqPro";
            delete reqPro;
        }

    }


}



void VmSql::sql_start()
{
    bool ok = sqlConnection();
    if(ok)
    {
        sqlConnected = true;
        emit sqlActionSignal(SQL_CONNECT_OK,NULL);
        productTableCheck();
        columnTableCheck();
    }
    else
    {
        emit sqlActionSignal(SQL_CONNECT_FAIL,NULL);
    }
    qDebug()<<"VmSql::VmSql"<<ok;
}


bool VmSql::sqlConnection()
{
    m_db = QSqlDatabase::addDatabase("QMYSQL");
    m_db.setHostName("localhost");
    m_db.setUserName("root");
    m_db.setPassword("123456");
    m_db.setDatabaseName("vmc");
    return m_db.open();
}






void VmSql::columnTableCheck()
{
    QSqlQuery query(m_db);
    query.exec("SELECT * FROM vmc_column");
    while(query.next())
    {
        bool ok;
        ColumnObject *column = new ColumnObject();
        quint32 id = query.value(0).toUInt(&ok);
        column->id = id;
        column->bin = id / 1000;
        column->column = id % 1000;
        column->state = query.value(3).toUInt(&ok);
        column->productNo = query.value(4).toUInt(&ok);
        qDebug()<<"column:"<<column;
        emit sqlActionSignal(SQL_COLUMN_ADD,column);
    }
}



//遍历商品数据库
void VmSql::productTableCheck()
{
    QSqlQuery query(m_db);
    query.exec("SELECT * FROM vmc_product");
    while(query.next()){
        bool ok;
       // QString id = query.value(0).toString();
        QString productNo = query.value(1).toString();
        QString productName = query.value(4).toString();
        quint32 productPrice = query.value(11).toUInt(&ok);
        ProductObject *productObj = new ProductObject();
        productObj->id = productNo;
        productObj->name = productName;
        productObj->salePrice = productPrice;
        //qDebug()<<"sqlAddProduct...obj="<<productObj;
        emit sqlActionSignal(SQL_PRODUCT_ADD,productObj);
    }
}


VmOrderObj *VmSql::sqlFindProductObj(const QString &product_id)
{

    VmOrderObj *obj = new VmOrderObj();
    //查找商品
    qDebug()<<"sqlFindProductObj..."<<product_id;
    QSqlQuery query(m_db);
    QString str = QString("SELECT * FROM vmc_product where productNo = '%1'")
                            .arg(product_id);

    bool ok = query.exec(str);
    qDebug()<<"sqlFindProductObj...ok="<<ok<<str;
    if(ok){
        while(query.next()){

            obj->id = product_id;
            obj->name = query.value(4).toString();
            obj->salePrice = query.value(11).toUInt(&ok);
            qDebug()<<"sqlFindProductObj name="<<obj->name;
            obj->buyNum = 1;
            break;
        }
    }

    if(obj->id  >  0){
        //查找 商品绑定的货道
        str = QString("SELECT * FROM vmc_column where productNo = '%1'")
                                .arg(product_id);
        ok = query.exec(str);
        while(query.next()){
            //选择第一个绑定的商品ID的货道
            quint8 state = query.value(3).toUInt(&ok);
            quint8 remain = query.value(5).toUInt(&ok);
            if(state != 1 || remain == 0) //没货 或者货道故障 找下一个货道
                continue;
            ColumnObject *column = new ColumnObject();
            column->bin = query.value(1).toUInt(&ok);
            column->column = query.value(2).toUInt(&ok);
            column->state = state;
            column->remain = remain;
            column->capacity = query.value(6).toUInt(&ok);
            obj->columnList<<column;
            qDebug()<<"sqlFindProductObj column="<<column->column;
        }
    }

    if(!obj->id.isEmpty() && obj->columnList.count()){
        return obj;
    }
    else{
        delete obj;
        return NULL;
    }

}

ProductObject *VmSql::sqlFindProduct(const QString &product_id)
{
    qDebug()<<"sqlFindProduct:"<<product_id;
    QSqlQuery query(m_db);
    QString str = QString("SELECT * FROM vmc_product where productNo = %1")
                            .arg(product_id);
    bool ok = query.exec(str);
    if(query.next())
    {
        ProductObject *productObj = new ProductObject();
        productObj->id = product_id;
        productObj->name = query.value(4).toString();
        productObj->salePrice = query.value(11).toUInt(&ok);
        productObj->buyNum++;
        return productObj;
    }

    return NULL;
}



