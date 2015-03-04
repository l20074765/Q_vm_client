#ifndef MAINOBJECT_H
#define MAINOBJECT_H

//负责与QML界面交互的主接口

#include <QObject>
#include <QCache>
#include <vmsql.h>
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
    Q_PROPERTY(int vmcState READ getVmcState WRITE setVmcState NOTIFY vmcStateChanged)
    Q_PROPERTY(QList<ProductObject *> productList READ getProductList WRITE setProductList NOTIFY vmProductListChanged)
    Q_PROPERTY(ProductHash productHash READ getProductHash WRITE setProductHash NOTIFY vmProductHashChanged)
    Q_PROPERTY(QImage picImage READ getPicImage WRITE setPicImage )
    Q_PROPERTY(QStringList adsFileList READ getAdsFileList WRITE setAdsFileList )

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
    void setPicImage(const QImage &image){picImage = image;}
    QImage getPicImage() {return picImage;}
    void setAdsFileList(const QStringList &list);
    QStringList getAdsFileList();
signals:
    void vmcStateChanged(QVariant state);
    void vmProductListChanged();
    void vmProductHashChanged();
    void sqlAddProductSignal();
    void tradeOverSignal();
    void tradeResultSignal(QVariant res);
    //支付宝信号发射
    void alipayTrade();
public slots:
    void qmlActionSlot(int v,QString req);
    void vmcpaySlot(int cabinet,int column,int type,long cost);
    void sqlProductChangedSlot();
    void sqlAddProductSLot(ProductObject *  obj);
    quint32 product_count(){return productHash.count();}
    ProductObject *getAddProductObj();
    void addProductFinish(QVariant p);
    void tradeOverSlot(QPixmap pic);
    void tradeResultSlot(int res);
    void EV_callBackSlot(const quint8 type,const void *ptr);

private:
    int vmcState;
    QHash<QString,ProductObject *> productHash;
    QHash<QString,QVariant> productQmlHash;

    //数据库接口类
    VmSql *vmsql;

    QList<ProductObject *> productList;
    ProductObject *productObj;

    //主控板通信接口类
    VmcMainFlow *vmcMainFlow;


    QPixmap pic;
    QImage picImage;
    QStringList adsFileList;

    //支付宝类接口以及线程
    AlipayAPI *alipayApi;
    QThread *alipayThread;



    QList<ProductObject *>productSelectList;//用户当前所选择的商品数

};

#endif // MAINOBJECT_H
