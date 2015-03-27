#include "vmsqlite.h"
#include <QtDebug>

VMSqlite::VMSqlite(QObject *parent) : QObject(parent)
{
    sqlConnected = false;
    productList = new SqlProductList(this);
    columnList = new SqlColumnList(this);
}

VMSqlite::~VMSqlite()
{
    m_db.close();
}


//启动数据库
void VMSqlite::sqlActionSlot(QVariant type,QVariant obj)
{

    int mt = type.value<int>();
    qDebug()<<trUtf8("数据库线程操作")<<" type="<<type<<" obj="<<obj
           <<QThread::currentThread()<<"mt="<<mt;
    if(mt == SQL_START)
    {
        sqlStart();
    }
    else if(mt == SQL_COLUMN_CHECK){
        checkTableColumn();
    }
    else if(mt == SQL_ORDER_MAKE){

    }


}




void VMSqlite::getProducts(int count, SqlProduct *curProduct, SqlProductList *list)
{
#if 0
    QString sql_code = "select myindex from "+ "vmc_product"
            +"where senderUin="+currentData->senderUin ()
            +" and message="+currentData->contentData ()
            +" and mydate="+currentData->date().toString ()
            +" and mytime="+currentData->time().toString ();
    QSqlQuery sql_query = sqlite_db.exec (sql_code);
    if(sql_query.lastError ().type ()==QSqlError::NoError){//如果查询没有出错
        if(sql_query.size ()>0){
            int currentIndex = sql_query.value (0).toInt ();//当前数据的索引为
            sql_code = "select * from "+tableName
                    +"where myindex<"+QString::number (currentIndex)
                    +" and myindex<="+QString::number (currentIndex+count);
            sql_query.exec (sql_code);
            if(sql_query.lastError ().type ()==QSqlError::NoError){//如果查询没有出错
                qDebug()<<"查询多条数据完成，数据的个数："<<sql_query.size ();
                while(sql_query.next ()){
                    ChatMessageInfo *data = new ChatMessageInfo;
                    Utility *utility = Utility::createUtilityClass ();
                    data->setSenderUin (sql_query.value (1).toString ());//从第一个开始，因为0为index
                    data->setContentData (utility->stringUncrypt (sql_query.value (2).toString (), "XingchenQQ123"));
                    //取回聊天内容时要解密
                    data->setDate (QDate::fromString (sql_query.value (3).toString ()));
                    data->setTime (QTime::fromString (sql_query.value (4).toString ()));
                    datas->append (data);//将查询到的结果添加到列表中
                }
                //emit getDatasFinished (datas);//发送信号，告知数据获取完成
            }else{
                qDebug()<<"执行"<<sql_code<<"出错："<<sql_query.lastError ().text ();
            }
        }else{
            qDebug()<<"执行"<<sql_code<<"未查询到结果";
        }
    }else{
        qDebug()<<"执行"<<sql_code<<"出错："<<sql_query.lastError ().text ();
    }
#endif
}


void VMSqlite::checkTableProduct()
{
    qDebug()<<"checkTableProduct";
    QSqlQuery query(m_db);
    query.exec("SELECT * FROM vmc_product");
    while(query.next()){
        bool ok;
       // QString id = query.value(0).toString();
        SqlProduct *product = new SqlProduct();
        product->id = query.value(1).toString();
        product->name = query.value(4).toString();
        product->salePrice = query.value(6).toUInt(&ok);
        qDebug()<<"VMSqlite::checkTableProduct...obj="<<product;
        productList->hash.insert(product->id,product);
        productList->queue.append(product);
    }
    QObject *obj = productList;
    QVariant var;
    var.setValue(obj);
    emit sqlActionSignal(QVariant((int)SQL_PRODUCT_ADD),var);
}

void VMSqlite::checkTableColumn()
{
    QSqlQuery query(m_db);
    query.exec("SELECT * FROM vmc_column");
    while(query.next())
    {
        bool ok;
        SqlColumn *column = new SqlColumn();
        column->id = query.value(0).toUInt(&ok);
        column->bin = column->id / 1000;
        column->column = column->id % 1000;
        column->state = query.value(3).toUInt(&ok);
        column->productNo = query.value(4).toUInt(&ok);
        qDebug()<<"VMSqlite::checkTableColumn column:"<<column;
        columnList->hash.insert(column->id,column);
        columnList->queue<<column;
        columnList->multiHash.insert(column->productNo,column);
    }
    QVariant type((int)SQL_COLUMN_ADD);
    QVariant var;
    var.setValue((QObject *)columnList);
    emit sqlActionSignal(type,var);

}

void VMSqlite::sqlStart()
{
    if(openSqlDatabase("vmc"))
    {
        sqlConnected = true;
        emit sqlActionSignal(QVariant((int)SQL_CONNECT_OK) ,QVariant((int)0));
        createTableProduct();
        createTableColumn();

        checkTableProduct();
        checkTableColumn();
    }
    else
    {
        emit sqlActionSignal(QVariant((int)SQL_CONNECT_FAIL) ,QVariant((int)0));
    }
}



bool VMSqlite::openSqlDatabase(const QString &fileName)
{
    if(!m_db.isOpen()){//如果数据库未打开
        m_db = QSqlDatabase::addDatabase ("QSQLITE");
        m_db.setHostName ("localhost");
        m_db.setDatabaseName (fileName + ".db");
        m_db.setUserName ("root");
        m_db.setPassword ("123456");
        return  m_db.open();
    }
    return true;
}


bool VMSqlite::tableAvailable(const QString &tableName)
{
    if(tableName!="" && m_db.isOpen ()){//如果数据库已经打开
        QString temp = "create table if not exists "+
                        tableName +
                        "(myindex INTEGER,senderUin VARCHAR[16],message TEXT,mydate DATE,mytime TIME)";
        //创建一个表，如果这表不存在，表的列为uin message mydate mytime
        QSqlQuery query = m_db.exec (temp);
        if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
            return true;
        }else{
            qDebug()<<"执行"<<temp<<"出错："<<query.lastError ().text ();
        }
    }else{
        qDebug()<<"数据库未打开";
    }
    return false;
}



bool VMSqlite::createTableProduct()
{
    QString tableName = "vmc_product";
    if(m_db.isOpen ()){//如果数据库已经打开
        QString temp = "create table if not exists "+
                tableName + " (" +
                "id int unsigned primary key," +
                "productNo varchar(100)," +
                "sellTag varchar(200)," +
                "brandName varchar(200)," +
                "productName varchar(200)," +
                "aliasName varchar(200)," +
                "salesPrice decimal(10,0)," +
                "productTXT TEXT"
                        ")";
        //创建一个表，如果这表不存在，
        QSqlQuery query = m_db.exec (temp);
        if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
            return true;
        }else{
            qDebug()<<"执行"<<temp<<"出错："<<query.lastError ().text ();
        }
    }else{
        qDebug()<<"数据库未打开";
    }
    return false;
}


bool VMSqlite::createTableColumn()
{
    QString tableName = "vmc_column";
    if(m_db.isOpen ()){//如果数据库已经打开
        QString temp = "create table if not exists "+
                        tableName + " (" +
                        "id int unsigned primary key," +
                        "cabinetNo int," +
                        "columnNo int," +
                        "columnState int," +
                        "productNo varchar(100)," +
                        "remain int," +
                        "capacity int," +
                        "message TEXT" +
                        ")";
        //创建一个表，如果这表不存在，
        QSqlQuery query = m_db.exec (temp);
        if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
            return true;
        }else{
            qDebug()<<"执行"<<temp<<"出错："<<query.lastError ().text ();
        }
    }else{
        qDebug()<<"数据库未打开";
    }
    return false;
}



void VMSqlite::addOrder(const QString &productId, OrderList *orderList)
{
    QList<Order *> list = orderList->list;
    for(int i = 0;i < list.count();i++){
        Order *order = list.at(i);
        if(order && order->id == productId){
            order->buyNum++;
            return;
        }
    }

    //新添加商品
    Order *order = new Order(orderList);
    order->buyNum = 1;
    order->id = productId;

    SqlProduct *product = productList->hash.value(productId);
    if(product == NULL){
        qWarning()<<tr("VMSqlite::addOrder---product == NULL");
        return;
    }
    order->name = product->name;
    order->salePrice = product->salePrice;

    //绑定货道
    order->columnList.clear();
    order->columnList = columnList->multiHash.values(productId);
    orderList->list << order;
}





