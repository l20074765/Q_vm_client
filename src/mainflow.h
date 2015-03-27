#ifndef MAINFLOW_H
#define MAINFLOW_H

#include <QObject>
#include <QStringList>
#include "vmcmainflow.h"
#include "vmsqlite.h"
#include "alipayapi.h"
#include "orderlist.h"
#include <QVariant>

class QDeclarativeView;
class QDeclarativeContext;
class QDeclarativeItem;

class QGraphicsObject;

class MainFlow : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QStringList adsFileList READ getAdsFileList)


    Q_ENUMS(QmlEnumType)
    Q_ENUMS(QmlPayoutType)
    Q_ENUMS(QMLTradeType)
public:
    explicit MainFlow(QObject *parent = 0);
    ~MainFlow();

    enum QmlEnumType{
        QML_VMC_STATE = 0,
        QML_SQL_PRODUCT_ADD,
        QML_SQL_COLUMN_ADD,
        QML_ACTION_TRADE,
        QML_ACTION_ORDER_ADD,
        QML_ALI_PIC_OK,
        QML_PAYOUT_TYPE,
        QML_TRADE_TYPE,
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


    void addOrder(const QString &productId);

    void show();
signals:
    void qmlActionSignal(QVariant type,QVariant obj);

    void vmcActionSignal(QVariant type,QVariant obj);
    void sqlActionSignal(QVariant type,QVariant obj);
    void aliActionSignal(QVariant type,QVariant obj);
public slots:
    void obj_destroy();
    void qmlActionSlot(QVariant type,QVariant obj);

    void vmcActionSlot(QVariant type,QVariant obj);
    void sqlActionSlot(QVariant type,QVariant obj);
    void aliActionSlot(QVariant type,QVariant obj);
private:
    QDeclarativeItem *mainItem;
    QDeclarativeContext *context;
    QDeclarativeView *view;



    //主控板通信接口类
    VmcMainFlow *vmcMainFlow;


    //sqlite数据库接口类
    VMSqlite *vmsqlite;
    QThread *sqlThread;//数据库线程类

    //订单管理类
    OrderList *orderList;


    //支付宝类接口以及线程
    AlipayAPI *alipayApi;
    QThread *alipayThread;

};

#endif // MAINFLOW_H
