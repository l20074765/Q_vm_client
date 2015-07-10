#include "vmsqlite.h"
#include <QtDebug>
#include "setting.h"

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
void VMSqlite::sqlActionSlot(int type,QObject *obj)
{
    qDebug()<<trUtf8("数据库线程操作")<<" type="<<type<<" obj="<<obj;
    int mt = type;
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
        SqlProduct *product = new SqlProduct(0);
        product->id = query.value(1).toString();
        product->name = query.value(4).toString();
        product->salePrice = query.value(6).toUInt(&ok);
        product->pic = query.value(8).toString();
        product->imagePath = vmConfig.productImagePath() + "/"  + product->id;

        product->images = vmConfig.getFilePicList(product->imagePath);
        QFile file(product->pic);
        if(!file.exists()){
            if(product->images.isEmpty()){
                product->pic = vmConfig.productDefaultPic();
            }
            else{
                product->pic = product->imagePath + "/" + product->images[0];
            }
        }
       // qDebug()<<"VMSqlite::checkTableProduct...obj="<<product<<product->imagePath;
        productList->hashInsert(product->id,product);


    }
    productList->getProductList();
    emit sqlActionSignal(SQL_PRODUCT_ADD,(QObject *)productList);

//    SqlProduct *p = new SqlProduct();
//    for(int i = 0;i < 10000;i++){
//        p->id = QString("vm%1").arg(i,4,10,QLatin1Char('0'));
//        insertProduct(p);
//    }

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
        column->productNo = query.value(4).toString();
        column->remain = query.value(5).toUInt(&ok);
        column->capacity = query.value(6).toUInt(&ok);
        qDebug()<<"VMSqlite::checkTableColumn column:"<<column<<column->productNo;
        columnList->hash.insert(column->id,column);
        columnList->list<<column;
        columnList->multiHash.insert(column->productNo,column);
    }

    emit sqlActionSignal(SQL_COLUMN_ADD,(QObject *)columnList);

}

void VMSqlite::sqlStart()
{
    if(openSqlDatabase("vmc"))
    {
        sqlConnected = true;
        emit sqlActionSignal(SQL_CONNECT_OK ,NULL);
        createTableCabinet();
        createTableProduct();
        createTableColumn();

        checkTableProduct();
        checkTableColumn();
    }
    else
    {
        emit sqlActionSignal(SQL_CONNECT_FAIL ,NULL);
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
                "id integer primary key AUTOINCREMENT," +
                "productNo varchar(100)," +
                "sellTag varchar(200)," +
                "brandName varchar(200)," +
                "productName varchar(200)," +
                "aliasName varchar(200)," +
                "salesPrice unsigned integer," +
                "productTXT TEXT," +
                "picture varchar(200)"
                        ")";// "salesPrice decimal(20,0)," +
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



bool VMSqlite::createTableCabinet()
{
    QString tableName = "vmc_cabinet";
    if(m_db.isOpen ()){//如果数据库已经打开
        QString temp = "create table if not exists "+
                        tableName + " (" +
                        "id integer primary key AUTOINCREMENT," +
                        "no     integer," +
                        "sum    integer," +
                        "type   integer," +
                        "info   TEXT" +
                        ")";
        //创建一个表，如果这表不存在，
        QSqlQuery query = m_db.exec (temp);
        if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
            return true;
        }else{
            qDebug()<<"执行"<<temp<<"出错："<<query.lastError().text ();
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
                        "id integer primary key AUTOINCREMENT," +
                        "cabinetNo integer," +
                        "columnNo integer," +
                        "columnState integer," +
                        "productNo varchar(100)," +
                        "remain integer," +
                        "capacity integer," +
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



bool VMSqlite::updateProduct(const SqlProduct *product)
{
    QString tableName = "vmc_product";
    if(!m_db.isOpen()){
        qDebug()<<"updateProduct:"<< "数据库未打开";
        return false;
    }

    QString temp = QString("update %1 set sellTag='%2',brandName='%3',productName='%4',aliasName='%5',salesPrice='%6',productTXT='%7',picture='%8' where productNo='%9'")
            .arg(tableName).arg(product->sellTag).arg(product->brandName)
            .arg(product->name).arg(product->aliasName).arg(product->salePrice)
            .arg(product->productTXT).arg(product->pic).arg(product->id);

    qDebug()<<"updateProduct:"<<"temp="<<temp;
    QSqlQuery query = m_db.exec (temp);
    if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
        return true;
    }else{
        qDebug()<<"updateProduct:执行"<<temp<<"出错："<<query.lastError ().text ();
        return false;
    }

}

bool VMSqlite::deleteProduct(const QString &productNo)
{
    QString tableName = "vmc_product";
    if(!m_db.isOpen()){
        qDebug()<<"deleteProduct:"<< "数据库未打开";
        return false;
    }

    QString temp = QString("delete from %1 where productNo='%2'")
            .arg(tableName).arg(productNo);

    qDebug()<<"deleteProduct:"<<"temp="<<temp;
    QSqlQuery query = m_db.exec (temp);
    if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
        return true;
    }else{
        qDebug()<<"deleteProduct:执行"<<temp<<"出错："<<query.lastError ().text ();
        return false;
    }
}

bool VMSqlite::insertProduct(const SqlProduct *product)
{
    QString tableName = "vmc_product";
    if(!m_db.isOpen()){
        qDebug()<<"insertProduct:"<< "数据库未打开";
        return false;
    }

    QString temp = QString("insert into %1 values(NULL,'%2','%3','%4','%5','%6',%7,'%8','%9')")
            .arg(tableName).arg(product->id).arg(product->sellTag)
            .arg(product->brandName).arg(product->name).arg(product->aliasName)
            .arg(product->salePrice).arg(product->productTXT).arg(product->pic);

    qDebug()<<"insertProduct:"<<"temp="<<temp;
    QSqlQuery query = m_db.exec (temp);
    if(query.lastError ().type ()==QSqlError::NoError){//如果上面的语句执行没有出错
        return true;
    }else{
        qDebug()<<"insertProduct:执行"<<temp<<"出错："<<query.lastError ().text ();
        return false;
    }


}

void VMSqlite::addOrder(const QString &productId, OrderList *orderList)
{
    qDebug()<<"VMSqlite::addOrder--"<<"productId=="<<productId<<
              " orderList="<<orderList;

    QList<Order *> list = orderList->list;
    for(int i = 0;i < list.count();i++){
        Order *order = list.at(i);
        if(order && order->id == productId){
            order->buyNum++;
            return;
        }
    }
    //新添加商品
    Order *order = new Order();
    order->buyNum = 1;
    order->id = productId;


    SqlProduct *product = productList->hashValue(productId);
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


bool VMSqlite::vmDeleteProduct(const QString &productId)
{
    SqlProduct *p = productList->hashValue(productId);
    if(p == NULL){
        qDebug()<<"vmInsertProduct:p=NULL";
        return false;
    }
    else{
       deleteProduct(productId);//删除数据库
       vmConfig.deleteDir(p->imagePath);//删除图片文件夹
       productList->remove(productId);//删除链表
    }
}

bool VMSqlite::vmUpdateProduct(const QString &productId)
{
    SqlProduct *p = productList->hashValue(productId);
    if(p == NULL){
        qDebug()<<"vmInsertProduct:p=NULL";
        return false;
    }
    else{
       return updateProduct(p);
    }
}

bool VMSqlite::vmInsertProduct(const QString &productId)
{
    SqlProduct *p = productList->hashValue(productId);
    if(p == NULL){
        qDebug()<<"vmInsertProduct:p=NULL";
        return false;
    }
    else{
        return insertProduct(p);
    }
}



