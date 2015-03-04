#include "mainobject.h"
#include <QtDebug>
#include <QMetaType>
#include <QThread>


#include <QFile>
#include <QDir>

MainObject::MainObject(QObject *parent) : QObject(parent)
{
    qDebug()<<trUtf8("Create MainObject");
    vmcState = 0;
    productObj = NULL;
    productList.clear();
    productQmlHash.clear();
    vmsql = new VmSql();
    vmsql->startThread();


    alipayApi = new AlipayAPI();
    alipayThread = new QThread(this);
    alipayApi->moveToThread(alipayThread);


    connect(alipayApi,SIGNAL(tradeOverSignal(QPixmap)),
            this,SLOT(tradeOverSlot(QPixmap)),Qt::QueuedConnection);

    connect(alipayApi,SIGNAL(tradeResultSignal(int)),
            this,SLOT(tradeResultSlot(int)),Qt::QueuedConnection);

    connect(this,SIGNAL(alipayTrade()),alipayApi,SLOT(tradBegin()),Qt::QueuedConnection);


    qRegisterMetaType<ProductHash>("ProductHash");//注册元对象

    connect(vmsql,SIGNAL(sqlProductChanged()),
            this,SLOT(sqlProductChangedSlot()),Qt::QueuedConnection);

    connect(vmsql,SIGNAL(sqlAddProduct(ProductObject * )),
            this,SLOT(sqlAddProductSLot(ProductObject * ))
            ,Qt::QueuedConnection);

    //启动后台通信
    qDebug()<<"Start vmc ...COM7";
    vmcMainFlow = new VmcMainFlow(0,QString("COM1"));
    connect(vmcMainFlow,SIGNAL(EV_callBackSignal(quint8,const void*)),
            this,SLOT(EV_callBackSlot(quint8,const void*)),Qt::QueuedConnection);
    vmcMainFlow->vmcStart();
    alipayThread->start();
}

MainObject::~MainObject()
{
    vmsql->deleteLater();
}


void MainObject::tradeOverSlot(QPixmap pic)
{
    qDebug()<<"tradeOverSlot"<<pic;
    this->pic = pic;
    this->picImage = pic.toImage();
    emit tradeOverSignal();
}

void MainObject::tradeResultSlot(int res)
{
    QVariant var;
    var.setValue(res);
    tradeResultSignal(var);
    //开始出货
    if(res == 1)
    {
        vmcMainFlow->EV_trade(1,11,1,0);
    }
}


void MainObject::qmlActionSlot(int v,QString req)
{
    qDebug()<<"qmlActionSlot:"<<v<<req;
    if(v == 1)
    {
       vmcpaySlot(1,11,1,0);
    }
}

void MainObject::vmcpaySlot(int cabinet,int column,int type,long cost)
{
    qDebug()<<trUtf8("出货前准备检测支付结果")<<"cabinet:"<<cabinet
           <<" column:"<<column
          <<" type:"<<type<<" cost:"<<cost;

    qDebug()<<trUtf8("当前线程:")<<QThread::currentThread();
    emit alipayTrade();
   // alipayApi->tradBegin();
}


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
    QVariant var;
    var.setValue(vmcState);
    emit vmcStateChanged(var);
}


void MainObject::sqlAddProductSLot(ProductObject *  obj)
{
    qDebug()<<"sqlAddProductSlot.."<<obj;
    productList<<obj;
    emit sqlAddProductSignal();
}


ProductObject * MainObject::getAddProductObj()
{
    if(productList.isEmpty())
        return NULL;
    ProductObject *obj = productList.first(); //添加
    productObj = obj;
    productList.removeFirst();//删除链表
    return obj;
}


void MainObject::addProductFinish(QVariant p)
{
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
}


void MainObject::sqlProductChangedSlot()
{
    productHash =  vmsql->getProductHash();
    qDebug()<<"emit vmProductListChanged()"<<productHash<<productHash.count();

    emit vmProductListChanged();

}
