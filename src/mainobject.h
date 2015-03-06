#ifndef MAINOBJECT_H
#define MAINOBJECT_H

//负责与QML界面交互的主接口

#include <QObject>
#include <QCache>
#include "vmsql.h"
#include <productobject.h>
#include <QHash>
#include "alipayapi.h"
#include "vmcmainflow.h"
#include <QPixmap>
#include <QImage>
#include <QStringList>
#include <QThread>

class MainObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int vmcState READ getVmcState WRITE setVmcState)
    Q_PROPERTY(QList<ProductObject *> productList READ getProductList WRITE setProductList)
    Q_PROPERTY(ProductHash productHash READ getProductHash WRITE setProductHash)
    Q_PROPERTY(QImage picImage READ getPicImage WRITE setPicImage )
    Q_PROPERTY(QStringList adsFileList READ getAdsFileList WRITE setAdsFileList )

    Q_ENUMS(QmlType)
    Q_ENUMS(QmlPayRstType)
public:
    explicit MainObject(QObject *parent = 0);
    ~MainObject();
    typedef QHash<QString,ProductObject *> ProductHash;
    void setVmcState(const int state);
    int getVmcState()const {return vmcState;}
    QList<ProductObject *> getProductList(){return productList;}
    void setProductList(QList<ProductObject *> list){productList = list;}
    ProductHash getProductHash(){return productHash;}
    void setProductHash(ProductHash hash){productHash = hash;}

    QList<ProductObject*> getProductSelectList(){return productSelectList;}

    void setPicImage(const QImage &image){picImage = image;}
    QImage getPicImage() {return picImage;}
    void setAdsFileList(const QStringList &list);
    QStringList getAdsFileList();


    enum QmlType{
        QML_TYPE_PRODUCT_ADD,
        QML_TYPE_VMC_STATE,
        QML_TYPE_PIC_OK,
        QML_TYPE_PAYOUT,
        QML_TYPE_GOODS_SELECT,
        QML_TYPE_TRADE,
        QML_TYPE_TRADE_CLEAR
    };

    enum QmlPayRstType{
        QML_PAYOUT_SUC,
        QML_PAYOUT_NET_ERR,
        QML_PAYOUT_FAIL
    };


signals:
    //qml信号发送
    void qmlActionSignal(QVariant type,QVariant var);

    //数据库信号发射操作
    void sqlActionSignal(int type,QObject *obj);

    //支付宝信号发射
    void aliRequstSignal(int type,QObject *obj);
public slots:
    void qmlActionSlot(int v,QString req);
    void vmcpaySlot(int cabinet,int column,int type,long cost);    
    void sqlAddProductSLot(ProductObject *  obj);
    quint32 product_count(){return productHash.count();}
    ProductObject *getAddProductObj();
    void addProductFinish(QVariant p);
    void EV_callBackSlot(const quint8 type,const void *ptr);

    //数据库接收槽
    void sqlActionSlot(int type,QObject *obj);


    //支付宝槽
    void aliActionSlot(int type,QObject *obj);

    //定时器槽
    void timeroutSlot();
private:
    int vmcState;
    QHash<QString,QVariant> productQmlHash;

    //数据库接口类
    VmSql *vmsql;
    QThread *sqlyThread;//数据库线程类
    QList<ProductObject *> productList;
    QList<ProductObject *> productSelectList;//用户当前所选择的商品数
    QHash<QString,ProductObject *> productHash;

    //主控板通信接口类
    VmcMainFlow *vmcMainFlow;


    QPixmap pic;
    QImage picImage;
    QStringList adsFileList;

    //支付宝类接口以及线程
    AlipayAPI *alipayApi;
    QThread *alipayThread;



    QTimer *timer;
};

#endif // MAINOBJECT_H
