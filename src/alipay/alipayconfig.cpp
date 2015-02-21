#include "alipayconfig.h"

AlipayConfig::AlipayConfig(QObject *parent) : QObject(parent)
{

    gatewayStr = "https://mapi.alipay.com/gateway.do?";
    charset = "utf-8";
    seller_email = "2544282805@qq.com";
    partner = "2088711021642556";
    key = "q4qsttz5r4grwnr5y5h9shjzvjfxejco";
    str_precreate = "alipay.acquire.precreate";
    str_query = "alipay.acquire.query";
}

AlipayConfig::~AlipayConfig()
{

}

