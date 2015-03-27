#ifndef ALIPAYAPI_H
#define ALIPAYAPI_H

#include <QObject>
#include <QMap>
#include <QPixmap>
#include "alipayconfig.h"
#include <QThread>
#include <QXmlStreamReader>
#include "alixmlobj.h"

#include <QHash>
#include <QVariant>
class QTimer;
class QNetworkReply;
class QNetworkAccessManager;



class AlipayAPI : public QObject
{
    Q_OBJECT
public:
    explicit AlipayAPI(QObject *parent = 0);
    ~AlipayAPI();




    QString buildRequest(const QMap<QString,QString> &mapArr);
    QMap<QString,QString> filterPara(const QMap<QString,QString> &mapArr);
    QString createLinkString(const QMap<QString,QString> &mapArr);
    QString buildRequestMysign(const QMap<QString,QString> &mapArr);

    enum{
        ALI_ACTION_PIC_OK,
        ALI_ACTION_TRADE_SUC,
        ALI_ACTION_TRADE_FAIL,
        ALI_ACTION_TRADE_START,
        ALI_ACTION_NETWORK_ERR,
        ALI_ACTION_TRADE_CLEAR
    };

    QByteArray picArr;
    QString picUrl;

signals:
    void aliActionSignal(QVariant type,QVariant obj);
public slots:
    void aliActionSlot(QVariant type,QVariant obj);

    void timerout_ali_checked();
    void network_recved(QNetworkReply *reply); //支付http回应处理
private:
    QNetworkAccessManager *network_man; //支付htpp管理
    QTimer *timer_check;//查询订单状态定时器
    bool ali_isChecked;
    QString str_cur_ali_type;//当前与支付宝通信类型
    QString str_cur_ali_trade_no;//当前的订单交易号
    AlipayConfig *aliConfig;
    void tradBegin(QObject *obj);
    void aliXmlResolve(QHash<QString,QString> *xmlHash,QXmlStreamReader *xml);
    void aliResponseResolve(QHash<QString,QString> *xmlHash);
    QHash<QString,QString> xmlHash;
};

#endif // ALIPAYAPI_H
