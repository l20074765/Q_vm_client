#include "vmsql.h"


#include <QSqlRecord>

#include <QtDebug>
#include <QMetaType>


VmSql::VmSql(QObject *parent) : QObject(parent)
{
    sqlConnected = false;
    m_model = NULL;
    m_modelCabinet = NULL;
    productHash.clear();
    connect(this,SIGNAL(sqlActionSignal(int,QObject*)),
            this,SLOT(sqlRptSlot(int,QObject*)));






}

VmSql::~VmSql()
{

}




//启动数据库
void VmSql::requestHandle(int type,QObject *obj)
{
    qDebug()<<trUtf8("数据库线程操作")<<"type="<<type;
    if(type == SQL_TYPE_START)
    {
        sql_start();
    }


}



void VmSql::sql_start()
{
    bool ok = sqlConnection();
    if(ok)
    {
        sqlConnected = true;
        emit sqlActionSignal(SQL_CONNECT_OK,NULL);
    }
    else
    {
        emit sqlActionSignal(SQL_CONNECT_FAIL,NULL);
    }
    qDebug()<<"VmSql::VmSql"<<ok;
}

void VmSql::sqlRptSlot(int type,QObject *obj)
{
    if(type == SQL_CONNECT_OK)
    {
         tabelModelInit();
         productTableCheck();
    }
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

void VmSql::tabelModelInit()
{
    m_model = new QSqlTableModel(this,m_db);
    m_modelCabinet = new QSqlTableModel(this,m_db);
    m_modelCabinet->setTable("vmc_cabinet1");
    m_modelCabinet->setEditStrategy(QSqlTableModel::OnManualSubmit);
}


void VmSql::productTableCheck()
{
    m_model->setTable("vmc_product");
    m_model->setEditStrategy(QSqlTableModel::OnManualSubmit);
    m_model->select();

    qDebug()<<"productTableCheck:"<<m_model->columnCount()
           <<m_model->rowCount();
    bool ok;
    int key = m_model->record().indexOf("productNo");
    for(int i = 0;i < m_model->rowCount();i++)
    {
        QSqlRecord record = m_model->record(i);

        QString productNo = record.value("productNo").toString();
        qDebug()<<"productNo:"<<productNo;

        //第二种方式通过索引搜索 使用大数据 推荐
        QString productNo1 = record.value(key).toString();        
        qDebug()<<"productNo1:"<<productNo1;
        //处理数据
        ProductObject *productObj = new ProductObject();
        productObj->id = productNo1;
        productObj->name = record.value("productName").toString();

        quint32 priceInt = record.value("salesPrice").toUInt(&ok);
        productObj->salePrice = QString("%1.%2")
                .arg(priceInt/100)
                .arg(priceInt % 100,2,10,QLatin1Char('0'));

        qDebug()<<"sqlAddProduct..."<<productObj->salePrice;
        emit sqlActionSignal(SQL_ACTION_PRODUCT_ADD,productObj);
    }


}


ProductObject *VmSql::sqlFindProduct(const QString &product_id)
{
    qDebug()<<"sqlFindProduct:"<<product_id;
    int key = m_model->record().indexOf("productNo");


    for(int i = 0;i < m_model->rowCount();i++)
    {
        QSqlRecord record = m_model->record(i);
        QString producNo = record.value(key).toString();
        bool ok;
        if(producNo == product_id)//找到数据
        {
             ProductObject *productObj = new ProductObject();
             productObj->id = producNo;
             productObj->name = record.value("productName").toString();

             quint32 priceInt = record.value("salesPrice").toUInt(&ok);
             productObj->salePrice = QString("%1.%2")
                     .arg(priceInt/100)
                     .arg(priceInt % 100,2,10,QLatin1Char('0'));

             return productObj;
        }
    }


    return NULL;
}



