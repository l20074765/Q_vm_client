#include "mainobject.h"
#include <QtDebug>
#include <QMetaType>
#include <QThread>
#include "qqrencode.h"

#include <QFile>
#include <QDir>
#include <QTimer>


MainObject::MainObject(QObject *parent) : QObject(parent)
{
    qDebug()<<trUtf8("Create MainObject");
    vmcState = 0;
    productList.clear();
    productQmlHash.clear();

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
    qDebug()<<"Start vmc ...COM7";
    vmcMainFlow = new VmcMainFlow(0,QString("COM1"));
    connect(vmcMainFlow,SIGNAL(EV_callBackSignal(quint8,const void*)),
            this,SLOT(EV_callBackSlot(quint8,const void*)),Qt::QueuedConnection);
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
        vmcMainFlow->EV_trade(1,11,1,0);//开始出货
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




void MainObject::qmlActionSlot(int v,QString req)
{
    qDebug()<<"MainObject::qmlActionSlot:"<<v<<req;
    if(v == QML_TYPE_TRADE)
    {
       vmcpaySlot(1,11,1,0);
    }
    else if(v == QML_TYPE_GOODS_SELECT)
    {
       if(!req.isEmpty())
       {
           ProductObject *product =  productHash.value(req);
           if(product)
           {
               qDebug()<<"Select product id:"<<product->id
                      <<"Name:"<<product->name;
               if(productSelectList.contains(product))
               {
                  product->buyNum++;
               }
               else
               {
                   product->buyNum = 1;
                   productSelectList<<product;
               }


           }
       }
    }
    else if(v == QML_TYPE_TRADE_CLEAR)
    {
        productSelectList.clear();
        emit aliRequstSignal(AlipayAPI::ALI_ACTION_TRADE_CLEAR,NULL);
    }
}

void MainObject::vmcpaySlot(int cabinet,int column,int type,long cost)
{
    qDebug()<<trUtf8("出货前准备检测支付结果")<<"cabinet:"<<cabinet
           <<" column:"<<column<<" type:"<<type<<" cost:"<<cost;
    qDebug()<<trUtf8("当前线程:")<<QThread::currentThread();
    emit aliRequstSignal(AlipayAPI::ALI_ACTION_TRADE_START,this);
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
    qDebug()<<"MainObject::sqlActionSlot"<<type<<obj;
    if(type == VmSql::SQL_PRODUCT_ADD)
    {
        ProductObject *product = qobject_cast<ProductObject *>(obj);
        if(product)
        {
             sqlAddProductSLot(product);
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
            productSelectList<<product;
        }
    }
}


void MainObject::sqlAddProductSLot(ProductObject *  obj)
{
    qDebug()<<"sqlAddProductSlot.."<<obj;
    productHash.insert(obj->id,obj);
    productList<<obj;
    QVariant type,var;
    int t = QML_TYPE_PRODUCT_ADD;
    type.setValue(t);
    emit qmlActionSignal(type,var);
}


ProductObject * MainObject::getAddProductObj()
{
    if(productList.isEmpty())
        return NULL;
    ProductObject *obj = productList.first(); //添加
    productList.removeFirst();//删除链表
    return obj;
}


void MainObject::addProductFinish(QVariant p)
{

#if 0
    //对象显示完成后需要销毁该对象
    if(productObj)
    {
        productQmlHash.insert(productObj->id,p);
        qDebug()<<p;
        //销毁前
        //qDebug()<<QString("销毁对象")<<productObj;
        delete productObj;
        productObj = NULL;
    }
#endif
}



