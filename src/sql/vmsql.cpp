#include "vmsql.h"


#include <QSqlRecord>

#include <QtDebug>
#include <QMetaType>


VmSql::VmSql(QObject *parent) : QObject(parent)
{
    stopped = true;
    sqlConnected = false;
    m_model = NULL;
    m_modelCabinet = NULL;
    productHash.clear();

    //注册元对象
   // qRegisterMetaType<QHash<QString,ProductObject*>>("QHash<QString,ProductObject*>");
    connect(this,SIGNAL(sqlRptSignal(quint32)),
            this,SLOT(sqlRptSlot(quint32)),Qt::QueuedConnection);






}

VmSql::~VmSql()
{

}




//启动数据库
void VmSql::sql_start()
{
    bool ok = sqlConnection();
    if(ok)
    {
        sqlConnected = true;
        emit sqlRptSignal(SQL_CONNECT_OK);
    }
    else
    {
        emit sqlRptSignal(SQL_CONNECT_FAIL);
    }

    qDebug()<<"VmSql::VmSql"<<ok;

}



void VmSql::sqlRptSlot(quint32 type)
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
    //qDebug()<<QString("tabelModelInit。。。");
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
        emit sqlAddProduct(productObj);
#if 0
        if(!productHash.contains(productNo1)) //商品重合
        {
            productHash.insert(QString("%1").arg(productNo1),productOb);
            //新增商品 发送通知
        }
#endif

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



