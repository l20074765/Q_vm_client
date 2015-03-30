#include "mainflow.h"

#include <QtDebug>
#include <QDir>
#include <QVariant>

#include "vmvideo.h"
#include "qrenwidget.h"
#include "setting.h"
#include "sqlproduct.h"
#include "sqlproductlist.h"


MainFlow::MainFlow(QObject *parent) : QObject(parent)
{
    connect(this,SIGNAL(destroyed()),this,SLOT(obj_destroy()));

}

MainFlow::~MainFlow()
{
    qDebug()<<"MainFlow::~MainFlow()";
}



void MainFlow::init()
{
    //启动后台通信
    qDebug()<<"Start vmc ..."<<vmConfig.getVmPort();
    vmcMainFlow = new VmcMainFlow(this,vmConfig.getVmPort());
    connect(vmcMainFlow,SIGNAL(ActionSignal(QVariant,QVariant)),
            this,SLOT(vmcActionSlot(QVariant,QVariant)));
    connect(this,SIGNAL(vmcActionSignal(QVariant,QVariant)),
            vmcMainFlow,SLOT(ActionSlot(QVariant,QVariant)));

    vmcMainFlow->setVmcState(EV_STATE_FAULT);
    vmcMainFlow->vmcStart();

    //sqlite 数据库接口类
    vmsqlite =  new VMSqlite(this);

    connect(this,SIGNAL(sqlActionSignal(int,QObject *)),
            vmsqlite,SLOT(sqlActionSlot(int,QObject *)));
    connect(vmsqlite,SIGNAL(sqlActionSignal(int,QObject *)),
            this,SLOT(sqlActionSlot(int,QObject *)));

    //启动数据库
    emit sqlActionSignal(VMSqlite::SQL_START,NULL);


    //订单管理接口类
    orderList = new OrderList(this);


    //支付宝接口类
    alipayApi = new AlipayAPI(this);

    connect(alipayApi,SIGNAL(aliActionSignal(QVariant,QVariant)),
            this,SLOT(aliActionSlot(QVariant,QVariant)));
    connect(this,SIGNAL(aliActionSignal(QVariant,QVariant)),
            alipayApi,SLOT(aliActionSlot(QVariant,QVariant)));

}

void MainFlow::obj_destroy()
{
    qDebug()<<"MainFlow::destroy";
}




QStringList MainFlow::getAdsFileList()
{
    QStringList list;
    QDir dir("../../images/ads");
    QStringList filter;
    filter<<"*.jpg"<<"*.png"<<"*.avi";
    list = dir.entryList(filter);
    qDebug()<<tr("测试遍历文件")<<list;
    return list;
}



void MainFlow::sqlActionSlot(int type, QObject *obj)
{
    int mt = type;
    QVariant varType;
    QVariant varobj;
    if(mt == VMSqlite::SQL_PRODUCT_ADD){
        varType.setValue((int)QML_SQL_PRODUCT_ADD);
        varobj.setValue(obj);
    }
    else if(mt == VMSqlite::SQL_COLUMN_ADD){
        varType.setValue((int)QML_SQL_COLUMN_ADD);
        varobj.setValue(obj);

    }
    else if(mt == VMSqlite::SQL_ORDER_MAKE){//订单已经生产开始支付
        //SqlProductList *
        //aliActionSignal(AlipayAPI::ALI_ACTION_TRADE_START,obj);
    }
    else{
        return;
    }

    emit qmlActionSignal(varType,varobj);


}


void MainFlow::aliActionSlot(QVariant type, QVariant obj)
{
    qDebug()<<"MainFlow::aliActionSlot"<<type<<obj;
    QVariant qmlt,var;
    int t;
    if(type == AlipayAPI::ALI_ACTION_PIC_OK)//图片下载成功
    {
        qDebug()<<trUtf8("下载二维码图片成功准备保存");
        qmlt.setValue((int)QML_ALI_PIC_OK);
        var.setValue(QString(alipayApi->picArr));
        emit qmlActionSignal(qmlt,var);
    }
    else if(type == AlipayAPI::ALI_ACTION_TRADE_SUC)//支付成功
    {
        t = QML_PAYOUT_TYPE;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_SUC);
        emit qmlActionSignal(qmlt,var);//支付成功 准备开始出货

        QObject *objList = (QObject *)orderList;
        QVariant obj1;
        obj1.setValue(objList);
        emit vmcActionSignal(VmcMainFlow::VMC_ACTION_TRADE,obj1);
    }
    else if(type == AlipayAPI::ALI_ACTION_TRADE_FAIL)//支付失败
    {
        t = QML_PAYOUT_TYPE;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_FAIL);//支付失败 准备退出交易界面
        emit qmlActionSignal(qmlt,var);
    }
    else if(type == AlipayAPI::ALI_ACTION_NETWORK_ERR)//网络故障支付失败
    {
        t = QML_PAYOUT_TYPE;
        qmlt.setValue(t);
        var.setValue((int)QML_PAYOUT_NETWORK_ERR);
        emit qmlActionSignal(qmlt,var);
    }
}

void MainFlow::qmlActionSlot(QVariant type, QVariant obj)
{
    qDebug()<<tr("MainFlow:当前线程")<<QThread::currentThread();
    int mt = type.value<int>();
    if(mt == QML_ACTION_ORDER_ADD){
        QString productId = obj.value<QString>();
        vmsqlite->addOrder(productId,orderList);
    }
    else if(mt == QML_ACTION_TRADE){
        QVariant type((int)VMSqlite::SQL_ORDER_MAKE);
        QVariant obj1;
        obj1.setValue(((QObject *)orderList));
        emit aliActionSignal(type,obj1);//先从数据提取完整订单
    }
    else if(mt == QML_MAINFLOW_START){
        this->init();
    }
}

void MainFlow::vmcActionSlot(QVariant type, QVariant obj)
{
    qDebug()<<"MainObject::vmcActionSlot"<<type<<obj;
    QVariant varType;
    int mt = type.value<int>();
    if(mt == VmcMainFlow::VMC_ACTION_STATE)
    {
        varType.setValue((int)QML_VMC_STATE);
    }
    else if(mt == VmcMainFlow::VMC_ACTION_TRADE_OK){
        orderList->list.clear();
        QVariant var1((int)QML_TRADE_TYPE);
        QVariant var2((int)QML_TRADE_OK);
        emit qmlActionSignal(var1,var2);
    }
    else if(mt == VmcMainFlow::VMC_ACTION_TRADE_FAIL){
        orderList->list.clear();
        QVariant var1((int)QML_TRADE_TYPE);
        QVariant var2((int)QML_TRADE_FAIL);
        emit qmlActionSignal(var1,var2);
    }
    else{
        return;
    }

    emit qmlActionSignal(varType,obj);
}



