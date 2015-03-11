#ifndef MAINOBJECT_H
#define MAINOBJECT_H
//负责与QML界面交互的主接口
#include <QObject>
#include <QPixmap>
#include <QImage>
#include <QStringList>
#include <QThread>
#include <QHash>

#include "alipayapi.h"
#include "vmsql.h"
#include "vmcmainflow.h"
#include "productobject.h"
#include "productmanage.h"
#include "columnmanage.h"
#include "vmorder.h"

class MainObject : public QObject
{
    Q_OBJECT
    Q_PROPERTY(int vmcState READ getVmcState WRITE setVmcState)
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


    void setPicImage(const QImage &image){picImage = image;}
    QImage getPicImage() {return picImage;}
    void setAdsFileList(const QStringList &list);
    QStringList getAdsFileList();

    //QList<ProductObject*> getProductSelectList();

    ProductManage *getProductManage(){return this->productmanage;}
    ColumnManage *getColumnManage(){return this->columnManage;}

    enum QmlType{
        QML_TYPE_PRODUCT_ADD = 0,
        QML_TYPE_VMC_STATE,
        QML_TYPE_PIC_OK,
        QML_TYPE_PAYOUT,
        QML_TYPE_GOODS_SELECT,
        QML_TYPE_TRADE,
        QML_TYPE_TRADE_CLEAR,
        QML_TYPE_PRODUCT_SUM,
        QML_TYPE_TRADE_OK,
        QML_TYPE_TRADE_FAIL
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

    void vmcActionSignal(int type,QObject *obj);

    //支付宝信号发射
    void aliRequstSignal(int type,QObject *obj);
public slots:
    void qmlActionSlot(int v,QString req);
    void vmcpaySlot(int cabinet,int column,int type,long cost);    


    void EV_callBackSlot(const quint8 type,const void *ptr);

    //数据库接收槽
    void sqlActionSlot(int type,QObject *obj);
    //支付宝槽
    void aliActionSlot(int type,QObject *obj);
    void vmcActionSlot(int type,QObject *obj);
    //定时器槽
    void timeroutSlot();
private:
    int vmcState;
    QHash<QString,QVariant> productQmlHash;

    //数据库接口类
    VmSql *vmsql;
    QThread *sqlyThread;//数据库线程类
    //QList<ProductObject *> productSelectList;//用户当前所选择的商品数


    //主控板通信接口类
    VmcMainFlow *vmcMainFlow;


    QPixmap pic;
    QImage picImage;
    QStringList adsFileList;

    //支付宝类接口以及线程
    AlipayAPI *alipayApi;
    QThread *alipayThread;
    QTimer *timer;


    //商品管理接口类
    ProductManage *productmanage;

    //货道管理类
    ColumnManage *columnManage;

    //订单管理类
    VmOrder *vmOrder;
};

#endif // MAINOBJECT_H
