#ifndef MAINFLOW_H
#define MAINFLOW_H

#include <QObject>
#include <QStringList>
#include "vmcmainflow.h"
#include "vmsqlite.h"
#include "alipayapi.h"
#include "orderlist.h"
#include <QVariant>



class MainFlow : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList adsFileList READ getAdsFileList)
    Q_PROPERTY(QStringList productPicList READ getproductPicList)

    Q_ENUMS(QmlEnumType)
    Q_ENUMS(QmlPayoutType)
    Q_ENUMS(QMLTradeType)
public:
    explicit MainFlow(QObject *parent = 0);
    ~MainFlow();

    enum QmlEnumType{
        QML_VMC_STATE = 0,
        QML_SQL_PRODUCT_ADD,
        QML_SQL_PRODUCT_CREATE,
        QML_SQL_COLUMN_ADD,
        QML_SQL_COLUMN_CHANGE,
        QML_ACTION_TRADE,
        QML_ACTION_ORDER_ADD,
        QML_ALI_PIC_OK,
        QML_PAYOUT_TYPE,
        QML_TRADE_TYPE,
        QML_MAINFLOW_START,
        QML_DEFAULT
    };


    enum QmlPayoutType{
        QML_PAYOUT_SUC = 0,
        QML_PAYOUT_FAIL,
        QML_PAYOUT_PIC_OK,
        QML_PAYOUT_NETWORK_ERR
    };

    enum QMLTradeType{
        QML_TRADE_OK,
        QML_TRADE_FAIL
    };

    QStringList getAdsFileList();
    QStringList getproductPicList();
    VMSqlite *getVMSqlite();

  //  SqlProduct *sqlProduct;

protected:
    void init();
signals:
    void qmlActionSignal(QVariant type,QVariant obj);

    void vmcActionSignal(QVariant type,QVariant obj);
    void sqlActionSignal(int type,QObject *obj);
    void aliActionSignal(QVariant type,QVariant obj);
public slots:
    void obj_destroy();
    void qmlActionSlot(QVariant type,QVariant obj);

    void vmcActionSlot(QVariant type,QVariant obj);
    void sqlActionSlot(int type,QObject *obj);
    void aliActionSlot(QVariant type,QVariant obj);
    QString priceCheck(const QString &text);
private:

    //主控板通信接口类
    VmcMainFlow *vmcMainFlow;


    //sqlite数据库接口类
    VMSqlite *vmsqlite;

    //订单管理类
    OrderList *orderList;


    //支付宝类接口
    AlipayAPI *alipayApi;




};

#endif // MAINFLOW_H
