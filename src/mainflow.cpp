#include "mainflow.h"
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include <QDeclarativeEngine>
#include <QtDebug>
#include <QDir>
#include <QVariant>
#include <QWidget>
#include <QGraphicsView>


#include "vmvideo.h"
#include "qrenwidget.h"
#include "setting.h"
#include "sqlproduct.h"
#include "sqlproductlist.h"


MainFlow::MainFlow(QObject *parent) : QObject(parent)
{
    connect(this,SIGNAL(destroyed()),this,SLOT(obj_destroy()));

    view = new QDeclarativeView(0);

    view->engine()->addImportPath("modules");
    view->engine()->addPluginPath("./plugins");
    //让qml随窗口变化而变化
    view->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    view->setAttribute(Qt::WA_AutoOrientation,true);

    //推荐使用下面的一些QGraphicsView选项来优化QML UIs的性能
    view->setOptimizationFlag(QGraphicsView::DontSavePainterState);
    view->setViewportUpdateMode(QGraphicsView::BoundingRectViewportUpdate);
    view->scene()->setItemIndexMethod(QGraphicsScene::NoIndex);



    //注册组件到QML 让qml创建类 这种方式不好 让C++与qml通讯 采用上面的方式
    //提醒注册组件必须要在 this->setSource(url);之前进行 否则qml找不到组件
    qmlRegisterType<VMVideo>("Qtvm",1,0,"VMVideo");
    qmlRegisterType<QrenWidget>("Qtvm",1,0,"QrenWidget");
    qmlRegisterType<SqlProduct>("Qtvm",1,0,"SqlProduct");
    qmlRegisterType<SqlProductList>("Qtvm",1,0,"SqlProductList");
    qmlRegisterType<VmcMainFlow>("Qtvm",1,0,"VmcMainFlow");
    qmlRegisterType<VMSqlite>("Qtvm",1,0,"VMSqlite");
    qmlRegisterType<SqlColumn>("Qtvm",1,0,"SqlColumn");
    qmlRegisterType<SqlColumnList>("Qtvm",1,0,"SqlColumnList");
    qmlRegisterType<MainFlow>("Qtvm",1,0,"MainFlow");


    QUrl url;
    if(vmConfig.isQmlDebug())
        url = QUrl::fromLocalFile("../../qml/main.qml");
    else
        url = QUrl::fromLocalFile("qml/main.qml");
    qDebug()<<tr("QML文件路径:")<<url;
    view->setSource(url);
    view->setMinimumSize(QSize(768*0.5,1366*0.5));

    context = view->rootContext();
    context->setContextProperty("vm",this);
    context->setContextProperty("vmsqlite",this->vmsqlite);



    mainItem = qobject_cast<QDeclarativeItem *>(view->rootObject());
    qDebug()<<"mainItem:"<<mainItem;
    connect(mainItem,SIGNAL(qmlActionSignal(QVariant,QVariant)),
            this,SLOT(qmlActionSlot(QVariant,QVariant)));
    connect(this,SIGNAL(qmlActionSignal(QVariant,QVariant)),
            mainItem,SLOT(qmlActionSlot(QVariant,QVariant)));


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
    vmsqlite =  new VMSqlite();
    sqlThread = new QThread(this);
    vmsqlite->moveToThread(sqlThread);
    connect(this,SIGNAL(sqlActionSignal(QVariant,QVariant)),
            vmsqlite,SLOT(sqlActionSlot(QVariant,QVariant)),Qt::QueuedConnection);
    connect(vmsqlite,SIGNAL(sqlActionSignal(QVariant,QVariant)),
            this,SLOT(sqlActionSlot(QVariant,QVariant)),Qt::QueuedConnection);
    sqlThread->start();
    //启动数据库
    emit sqlActionSignal(VMSqlite::SQL_START,QVariant((int)0));


    //订单管理接口类
    orderList = new OrderList(this);


    //支付宝接口类
    alipayApi = new AlipayAPI();
    alipayThread = new QThread(this);
    alipayApi->moveToThread(alipayThread);
    connect(alipayApi,SIGNAL(aliActionSignal(QVariant,QVariant)),
            this,SLOT(aliActionSlot(QVariant,QVariant)),Qt::QueuedConnection);
    connect(this,SIGNAL(aliActionSignal(QVariant,QVariant)),
            alipayApi,SLOT(aliActionSlot(QVariant,QVariant)),Qt::QueuedConnection);
    alipayThread->start();


}

MainFlow::~MainFlow()
{
    qDebug()<<"MainFlow::~MainFlow()";
    view->deleteLater();
    if(sqlThread && sqlThread->isRunning())
    {
        sqlThread->terminate();
    }
    if(alipayThread && alipayThread->isRunning()){
        alipayThread->terminate();
    }
    alipayApi->deleteLater();
    vmsqlite->deleteLater();

}



void MainFlow::obj_destroy()
{
    qDebug()<<"MainFlow::destroy";
}


void MainFlow::show()
{
    view->show();
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



void MainFlow::sqlActionSlot(QVariant type, QVariant obj)
{
    int mt = type.value<int>();
    QVariant varType;
    if(mt == VMSqlite::SQL_PRODUCT_ADD){
        varType.setValue((int)QML_SQL_PRODUCT_ADD);
    }
    else if(mt == VMSqlite::SQL_COLUMN_ADD){
        varType.setValue((int)QML_SQL_COLUMN_ADD);
    }
    else if(mt == VMSqlite::SQL_ORDER_MAKE){//订单已经生产开始支付
        aliActionSignal(AlipayAPI::ALI_ACTION_TRADE_START,obj);
    }
    else{
        return;
    }

    emit qmlActionSignal(varType,obj);


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
    int mt = type.value<int>();
    if(mt == QML_ACTION_ORDER_ADD){
        QString productId = obj.value<QString>();
        addOrder(productId);
    }
    else if(mt == QML_ACTION_TRADE){
        QVariant type((int)VMSqlite::SQL_ORDER_MAKE);
        QVariant obj1;
        obj1.setValue(((QObject *)orderList));
        emit aliActionSignal(type,obj1);//先从数据提取完整订单
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



void MainFlow::addOrder(const QString &productId)
{
    vmsqlite->addOrder(productId,orderList);
}
