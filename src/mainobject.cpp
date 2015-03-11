#include "mainobject.h"
#include <QtDebug>
#include <QMetaType>
#include <QThread>
#include "qqrencode.h"

#include <QFile>
#include <QDir>
#include <QTimer>
#include <QVariant>
#include "setting.h"

MainObject::MainObject(QObject *parent) : QObject(parent)
{
    qDebug()<<trUtf8("Create MainObject");
    vmcState = 0;



    //创建商品接口类
    productmanage = new ProductManage(this);

    columnManage = new ColumnManage(this);

    vmOrder = new VmOrder(this);

    //数据库接口类
    vmsql = new VmSql();
    sqlyThread = new QThread(this);
    vmsql->moveToThread(sqlyThread);
    connect(this,SIGNAL(sqlActionSignal(int,QObject*)),
            vmsql,SLOT(sqlActionSlot(int,QObject*)),Qt::QueuedConnection);
    connect(vmsql,SIGNAL(sqlActionSignal(int,QObject*)),
            this,SLOT(sqlActionSlot(int,QObject*)),Qt::QueuedConnection);
    sqlyThread->start();//启动数据库线程

    //支付宝接口类
    alipayApi = new AlipayAPI();
    alipayThread = new QThread(this);
    alipayApi->moveToThread(alipayThread);
    connect(alipayApi,SIGNAL(aliActionSignal(int,QObject*)),
            this,SLOT(aliActionSlot(int,QObject*)),Qt::QueuedConnection);
    connect(this,SIGNAL(aliRequstSignal(int,QObject*)),
            alipayApi,SLOT(aliRequestSlot(int,QObject*)),Qt::QueuedConnection);
    alipayThread->start();


    qRegisterMetaType<ProductHash>("ProductHash");//注册元对象
    //启动后台通信
    qDebug()<<"Start vmc ..."<<vmConfig.getVmPort();

    vmcMainFlow = new VmcMainFlow(0,vmConfig.getVmPort());
    connect(vmcMainFlow,SIGNAL(vmcActionSignal(int,QObject *)),
            this,SLOT(vmcActionSlot(int,QObject *)),Qt::QueuedConnection);
    connect(this,SIGNAL(vmcActionSignal(int,QObject *)),
            vmcMainFlow,SLOT(vmcActionSlot(int,QObject *)),Qt::QueuedConnection);

    vmcMainFlow->vmcStart();


    //启动数据库
    emit sqlActionSignal(VmSql::SQL_START,NULL);


    //启动定时器
    timer = new QTimer(this);
    connect(timer,SIGNAL(timeout()),this,SLOT(timeroutSlot()));




}

MainObject::~MainObject()
{
    if(sqlyThread)
    {
        if(sqlyThread->isRunning())
            sqlyThread->terminate();
    }
    if(alipayThread)
    {
        if(alipayThread->isRunning())
            alipayThread->terminate();
    }

    vmsql->deleteLater();

}



/************************************************************************************
 * 定时器槽
 *
 * **********************************************************************************/
void MainObject::timeroutSlot()
{
    timer->stop();
}


/************************************************************************************
 * 支付宝操作函数
 *
 * **********************************************************************************/
void MainObject::aliActionSlot(int type, QObject *obj)
{
    qDebug()<<"MainObject::aliActionSlot"<<type<<obj;
    QVariant qmlt,var;
    int t;
    if(type == AlipayAPI::ALI_ACTION_PIC_OK)//图片下载成功
    {
        qDebug()<<trUtf8("下载二维码图片成功准备保存");
        qmlt.setValue((int)QML_TYPE_PIC_OK);
        var.setValue(QString(alipayApi->picArr));
        emit qmlActionSignal(qmlt,var);
    }
    else if(type == AlipayAPI::ALI_ACTION_TRADE_SUC)//支付成功
    {
        t = QML_TYPE_PAYOUT;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_SUC);
        emit qmlActionSignal(qmlt,var);
        emit vmcActionSignal(VmcMainFlow::VMC_ACTION_TRADE,vmOrder);
    }
    else if(type == AlipayAPI::ALI_ACTION_TRADE_FAIL)//支付失败
    {
        t = QML_TYPE_PAYOUT;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_FAIL);
        emit qmlActionSignal(qmlt,var);
    }
    else if(type == AlipayAPI::ALI_ACTION_NETWORK_ERR)//网络故障支付失败
    {
        t = QML_TYPE_PAYOUT;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_NET_ERR);
        emit qmlActionSignal(qmlt,var);
    }
}



//qml 与 C++连接槽函数
void MainObject::qmlActionSlot(int v,QString req)
{
    qDebug()<<"MainObject::qmlActionSlot:"<<v<<req;
    if(v == QML_TYPE_TRADE)
    {       
        emit aliRequstSignal(AlipayAPI::ALI_ACTION_TRADE_START,vmOrder);
    }
    else if(v == QML_TYPE_GOODS_SELECT)
    {   
       if(vmOrder->hasOrder(req)){
          vmOrder->addOrderBuyNum(req);//已添加商品直接新增购买数量
       }
       else{
           VmOrderObj *product = vmsql->sqlFindProductObj(req);
           if(product)
           {
               qDebug()<<"Select product id:"<<product->id
                      <<"Name:"<<product->name;
               vmOrder->addOrderList(product);
           }
       }
    }
    else if(v == QML_TYPE_TRADE_CLEAR)
    {
        //productmanage->clearProductBuyList();
        emit aliRequstSignal(AlipayAPI::ALI_ACTION_TRADE_CLEAR,NULL);
    }
    else if(v == QML_TYPE_PRODUCT_SUM)//回应商品总数
    {
        //return productHash.count();
    }
}

void MainObject::vmcpaySlot(int cabinet,int column,int type,long cost)
{
    qDebug()<<trUtf8("出货前准备检测支付结果")<<"cabinet:"<<cabinet
           <<" column:"<<column<<" type:"<<type<<" cost:"<<cost;
    qDebug()<<trUtf8("当前线程:")<<QThread::currentThread();
    emit aliRequstSignal(AlipayAPI::ALI_ACTION_TRADE_START,vmOrder);
}




void MainObject::vmcActionSlot(int type, QObject *obj)
{
    qDebug()<<"MainObject::vmcActionSlot"<<type<<obj;
    if(type == VmcMainFlow::VMC_ACTION_STATE)
    {
        VmcObj *vmc = qobject_cast<VmcObj *>(obj);
        if(vmc){
            int state = vmc->state;
            emit qmlActionSignal(QVariant((int)QML_TYPE_VMC_STATE),QVariant(state));
        }

    }
    else if(type == VmcMainFlow::VMC_ACTION_TRADE_OK){
        vmOrder->clearOrderList();
        emit qmlActionSignal(QVariant((int)QML_TYPE_TRADE_OK),QVariant(int(0)));
    }
    else if(type == VmcMainFlow::VMC_ACTION_TRADE_FAIL){
        vmOrder->clearOrderList();
        emit qmlActionSignal(QVariant((int)QML_TYPE_TRADE_FAIL),QVariant(int(0)));
    }
}


/************************************************************************************
 * 主控板通信操作函数
 *
 * **********************************************************************************/

void MainObject::EV_callBackSlot(const quint8 type,const void *ptr)
{
    qDebug()<<"MainWindow:EV_back type="<<QString("%1").arg(type,2,16,QLatin1Char('0')).toUpper();
    if(type == EV_STATE_RPT)
    {
       ST_STATE *state = (ST_STATE *)ptr;
       if(this->getVmcState() != state->vmcState)
       {
          this->setVmcState(state->vmcState);
       }

       if(state->vmcState == EV_STATE_DISCONNECT)
       {

       }
       else if(state->vmcState == EV_STATE_NORMAL)
       {

       }
       else if(state->vmcState == EV_STATE_FAULT)
       {

       }
    }
    else if(type == EV_ENTER_MANTAIN)//退出维护
    {
        this->setVmcState(EV_STATE_MANTAIN);
    }
    else if(type == EV_EXIT_MANTAIN)//推出维护
    {
        this->setVmcState(EV_STATE_FAULT);
    }
    else if(type == EV_COLUMN_RPT)
    {
        ST_COLUMN *q,*p;
        ST_COLUMN_RPT *column = (ST_COLUMN_RPT *)ptr;
        if(column == NULL) return;
        p = &column->head;
        //遍历链表
        while(p->next != NULL)
        {
            q = p->next;
            qDebug()<<"no=%d"<<q->no<<"state=%d"<<q->state;
            p = q;

        }
        qDebug()<<"EV_COLUMN_RPT";
    }
}




void MainObject::setAdsFileList(const QStringList &list)
{
    this->adsFileList = list;
}

QStringList MainObject::getAdsFileList()
{
    QStringList list;
    QDir dir("../../images/ads");
    QStringList filter;
    filter<<"*.jpg"<<"*.png"<<"*.avi";
    list = dir.entryList(filter);
    qDebug()<<"测试遍历文件"<<list;



    return list;


}



void MainObject::setVmcState(const int state)
{
    qDebug()<<"MainObject::setVmcState="<<state<<this;
    vmcState = state;
    QVariant type,var;
    var.setValue(vmcState);
    int t = QML_TYPE_VMC_STATE;
    type.setValue(t);
    emit qmlActionSignal(type,var);
}


/************************************************************************************
 * 数据库槽即操作函数
 *
 * **********************************************************************************/
void MainObject::sqlActionSlot(int type, QObject *obj)
{
    qDebug()<<"MainObject::sqlActionSlot:type="<<type<<"obj="<<obj;
    if(type == VmSql::SQL_PRODUCT_ADD)
    {
        ProductObject *product = qobject_cast<ProductObject *>(obj);
        if(product)
        {
            productmanage->addProduct(product);
            QVariant var;
            QVariant type((int)QML_TYPE_PRODUCT_ADD);
            emit qmlActionSignal(type,var);
        }

    }
    else if(type == VmSql::SQL_CONNECT_OK)//数据库连接成功
    {

    }
    else if(type == VmSql::SQL_CONNECT_FAIL)//数据库连接失败
    {

    }
    else if(type == VmSql::SQL_GOODS_SELECT)
    {
        ProductObject *product =  qobject_cast<ProductObject *>(obj);
        if(product)
        {
            qDebug()<<"Select product id:"<<product->id
                   <<"Name:"<<product->name;
          //  productSelectList<<product;
        }
    }
    else if(type == VmSql::SQL_COLUMN_ADD)
    {
        ColumnObject *column = qobject_cast<ColumnObject *>(obj);
        if(column){
            columnManage->addColumn(column);
        }
    }

}










