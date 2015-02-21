#include "mainwindow.h"

#include <QDeclarativeContext>
#include <QDeclarativeView>
#include <QDeclarativeItem>
#include <QDeclarativeEngine>
#include <QtDebug>
#include <QDir>
#include <QWidget>


MainWindow::MainWindow(QWidget *parent) :
    QDeclarativeView(parent)
{
    QUrl url;
    url = QUrl::fromLocalFile("../../qml/main.qml");
    this->setSource(url);
    // this->setFixedSize(QSize(768*0.5,1366*0.5));
    this->setMinimumSize(QSize(768*0.5,1366*0.5));
    //让qml随窗口变化而变化
    this->setResizeMode(QDeclarativeView::SizeRootObjectToView);
    this->engine()->addPluginPath("./plugins");


    mainObject = new MainObject(this);
    context = this->rootContext();
    context->setContextProperty("vm",mainObject);
    //注册组件到QML 让qml创建类 这种方式不好 让C++与qml通讯 采用上面的方式
    qmlRegisterType<MainObject>("MainObject", 1, 0, "MainObject");
    qmlRegisterType<ProductObject>("ProductObject",1,0,"ProductObject");
    //setOpacity(0.8);
    mainItem = qobject_cast<QDeclarativeItem *>(this->rootObject());
    qDebug()<<"mainItem"<<mainItem;


    connect(mainObject,SIGNAL(vmcStateChanged(QVariant)),
            mainItem,SLOT(vmcStatehandle(QVariant)),Qt::DirectConnection);


    connect(mainObject,SIGNAL(sqlAddProductSignal()),
            mainItem,SLOT(vmcproductAdd()),Qt::DirectConnection);


    connect(mainItem,SIGNAL(qmlActionSignal(int)),
            mainObject,SLOT(qmlActionSlot(int)),Qt::QueuedConnection);

    connect(mainObject,SIGNAL(tradeOverSignal()),
            mainItem,SLOT(alipay_pic_ok()),Qt::QueuedConnection);
    connect(mainObject,SIGNAL(tradeResultSignal(QVariant)),
            mainItem,SLOT(tradeResult(QVariant)));
#if 0
    connect(mainObject,SIGNAL(vmProductListChanged()),
            mainItem,SLOT(vmcproductChanged()),Qt::DirectConnection);







#endif


    mainObject->setVmcState(EV_STATE_DISCONNECT);



}

MainWindow::~MainWindow()
{

}






void MainWindow::setUiState(quint8 state)
{
    QVariant returnVar;
    QVariant s = state;
    if(mainItem == NULL) return;
    QMetaObject::invokeMethod(mainItem,"vmcStatehandle",
                         Q_RETURN_ARG(QVariant, returnVar),
                         Q_ARG(QVariant, s));

}


void MainWindow::qmlCreateProduct()
{
    QVariant product;
    if(mainItem == NULL) return;
    QMetaObject::invokeMethod(mainItem,"vmCreateProduct",
                         Q_RETURN_ARG(QVariant, product));

    //productList.append(product);
}


void MainWindow::qmlDeleteProduct()
{
    QVariant product;
    if(mainItem == NULL) return;
    QMetaObject::invokeMethod(mainItem,"vmDeleteProduct",
                         Q_ARG(QVariant, product));

}


