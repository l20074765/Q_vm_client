#include "mainview.h"
#include <QWidget>
#include <QGraphicsView>
#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include <QDeclarativeEngine>
#include <QtDebug>


#include "setting.h"
#include "vmvideo.h"
#include "qrenwidget.h"


MainView::MainView(QObject *parent) : QObject(parent)
{

    //开启后台子线程
    mainFlow = new MainFlow(0);
    mainThread = new QThread(this);
    mainFlow->moveToThread(mainThread);

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
    context->setContextProperty("mainView",this);
    context->setContextProperty("vm",this->mainFlow);
    VMSqlite *sqllite = mainFlow->getVMSqlite();
    context->setContextProperty("vmSqlite",sqllite);

    SqlProductList *sqlProductList = sqllite->getSqlProductList();
    SqlColumnList *sqlColumnList = sqllite->getSqlColumnList();

    //context->setContextProperty("sqlProduct",mainFlow->sqlProduct);
    context->setContextProperty("sqlProductList",sqlProductList);
    context->setContextProperty("sqlColumnList",sqlColumnList);



    mainItem = qobject_cast<QDeclarativeItem *>(view->rootObject());
    qDebug()<<"mainItem:"<<mainItem;

    connect(mainItem,SIGNAL(qmlActionSignal(QVariant,QVariant)),
            this,SLOT(qmlActionSlot(QVariant,QVariant)));
    connect(this,SIGNAL(qmlActionSignal(QVariant,QVariant)),
            mainItem,SLOT(qmlActionSlot(QVariant,QVariant)));


    connect(this,SIGNAL(vmActionSignal(QVariant,QVariant)),
            mainFlow,SLOT(qmlActionSlot(QVariant,QVariant)),Qt::QueuedConnection);
    connect(mainFlow,SIGNAL(qmlActionSignal(QVariant,QVariant)),
            this,SLOT(vmActionSlot(QVariant,QVariant)),Qt::QueuedConnection);

    qDebug()<<tr("MainView:当前线程")<<QThread::currentThread();

    mainThread->start();//启动后台子线程
    emit vmActionSignal(QVariant((int)MainFlow::QML_MAINFLOW_START),QVariant(0));



}

MainView::~MainView()
{
    qDebug()<<"MainView::~MainView()----";
    view->deleteLater();
    if(mainThread && mainThread->isRunning()){
        mainThread->terminate();
        mainFlow->deleteLater();
    }
}



void MainView::show()
{
    view->show();
    //view->showFullScreen();
}


void MainView::qmlActionSlot(QVariant type, QVariant obj)
{
    //将qml信号 传递给 后端
     qDebug()<<tr("MainView:当前线程")<<QThread::currentThread();
     emit vmActionSignal(type,obj);

}

void MainView::vmActionSlot(QVariant type, QVariant obj)
{
    //将 后端的信号 传递给 qml
    emit qmlActionSignal(type,obj);
}
