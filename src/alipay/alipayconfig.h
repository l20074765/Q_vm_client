#ifndef ALIPAYCONFIG_H
#define ALIPAYCONFIG_H

#include <QObject>

class AlipayConfig : public QObject
{
    Q_OBJECT
public:
    explicit AlipayConfig(QObject *parent = 0);
    ~AlipayConfig();
    QString partner;//支付宝卖家PID号
    QString seller_email;//卖家支付宝邮箱帐户
    QString key;    //卖家商户秘钥
    QString charset;//字符编码
    QString gatewayStr;//url地址

    QString str_precreate;//统一预下单接口
    QString str_query;//查询接口
signals:

public slots:


private:






};

#endif // ALIPAYCONFIG_H
