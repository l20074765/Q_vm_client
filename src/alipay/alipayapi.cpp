#include "alipayapi.h"
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QPixmap>
#include <QImage>
#include <QXmlStreamReader>
#include <QCryptographicHash>
#include <QThread>
#include "json.h"
#include <QDateTime>
#include <QFile>

#include <QtDebug>


AlipayAPI::AlipayAPI(QObject *parent)
    : QObject(parent)
{
    network_man = new QNetworkAccessManager(this);
    connect(network_man,SIGNAL(finished(QNetworkReply*)),
            this,SLOT(network_recved(QNetworkReply*)),Qt::QueuedConnection);

    network_pic_man = new QNetworkAccessManager(this);
    connect(network_pic_man,SIGNAL(finished(QNetworkReply*)),
            this,SLOT(network_pic_recved(QNetworkReply*)),Qt::QueuedConnection);
    timer_check = new QTimer(this);
    connect(timer_check,SIGNAL(timeout()),this,SLOT(timerout_ali_checked()));
    ali_isChecked = false;
    aliConfig = new AlipayConfig(this);

}

AlipayAPI::~AlipayAPI()
{

}

//支付宝查询接口
void AlipayAPI::timerout_ali_checked()
{
    qDebug()<<"timerout_ali_checked";
    //轮训查询订单结果
    QMap<QString,QString> map;
    //接口名称
    str_cur_ali_type = aliConfig->str_query;
    map.insert("service",aliConfig->str_query);//收单查询接口
    map.insert("partner",aliConfig->partner);//支付宝 PID号
    map.insert("seller_email", aliConfig->seller_email);//卖家支付宝帐户
    map.insert("_input_charset",aliConfig->charset.toLower());//编码
    map.insert("out_trade_no",str_cur_ali_trade_no);//商户网站唯一订单号
    buildRequest(map);


}

void AlipayAPI::network_pic_recved(QNetworkReply *reply)
{
    if(reply->error() == QNetworkReply::NoError)
    {
        qDebug()<<"network_pic_recved:OK";
        QPixmap pic;

        pic.loadFromData(reply->readAll());
        //至此图片下载成功 开始查询支付结果
        QString fileName = "../../images/alipay/ali_code.png";
        QFile::remove(fileName);
        pic.save(fileName);
        tradeOverSignal(pic);
        timer_check->start(3000);
    }
    else
    {
        qDebug()<<"network_pic_recved:err";
    }
}


void AlipayAPI::network_recved(QNetworkReply *reply)
{
    qDebug()<<"network_recved";

    if(reply->error() == QNetworkReply::NoError)
    {
        bool ok;
        QByteArray json = reply->readAll();
        qDebug()<<json<<json.length();
        QXmlStreamReader xml(json);
        while(!xml.atEnd() && !xml.hasError())
        {
            //读取下一个element.
            QXmlStreamReader::TokenType token = xml.readNext();
            //如果获取的仅为StartDocument,则进行下一个
            if(token == QXmlStreamReader::StartDocument)
            {
                qDebug()<<"QXmlStreamReader::StartDocument:"
                       <<xml.name()<<xml.readElementText();
                continue;
            }

            //如果获取了StartElement,则尝试读取
            if(token == QXmlStreamReader::StartElement)
            {
                QString nameStr = xml.name().toString();
                if(nameStr == QString("is_success"))//请求是否成功
                {
                    //返回 "T"表示成功  "F"表示失败
                    if(xml.readElementText() == QString("T"))
                    {
                        //qDebug()<<"请求发送成功";
                    }
                    else
                    {
                        //qDebug()<<"请求发送失败";
                    }
                }
                else if(nameStr == QString("request"))//解析支付宝返回的请求 原样返回
                {
                    QXmlStreamAttributes attributes = xml.attributes();
                    while(!xml.atEnd())
                    {
                        token = xml.readNext();
                        if(token == QXmlStreamReader::StartElement)
                        {
                            if(xml.name() == "param")
                            {
                                attributes = xml.attributes();
                                if(attributes.hasAttribute("name"))
                                {
                                    QString typeStr = attributes.value("name").toString();
                                    if(typeStr == "service")//判断回应接口类型
                                    {
                                       QString tempStr = xml.readElementText();
                                       if(tempStr == aliConfig->str_precreate)//预下单
                                       {

                                       }
                                    }
                                    qDebug()<<"attributes.hasAttribute(\"name\")"
                                           <<typeStr;
                                }
                            }
                        }
                        else if(token == QXmlStreamReader::EndElement)
                        {
                            if(xml.name() == "request")//请求描述 完成
                            {
                                break;
                            }
                        }
                    }


                }
                else if(nameStr == QString("response"))//解析支付宝 回应结果
                {
                    while(!xml.atEnd())
                    {
                        QXmlStreamReader::TokenType tokenRes = xml.readNext();
                        if(tokenRes == QXmlStreamReader::StartElement)
                        {
                            if(xml.name() == "small_pic_url")//下载二维码图片
                            {
                                QString urlStr = xml.readElementText();
                                QNetworkRequest request;
                                request.setUrl(QUrl(urlStr));
                                network_pic_man->get(request);
                            }
                            else if(xml.name() == "result_code")//成功
                            {
                                qDebug()<<"回应成功";
                            }
                            else if(xml.name() == "trade_status")//交易状态
                            {
                                if(str_cur_ali_type == aliConfig->str_query)//查询交易状态
                                {
                                    if(xml.readElementText() == "TRADE_SUCCESS")//支付成功
                                    {                                        
                                        timer_check->stop();
                                        tradeResultSignal(1);
                                    }
                                    else if(xml.readElementText() == "TRADE_CLOSED")//交易结束
                                    {                                       
                                        timer_check->stop();
                                        tradeResultSignal(0);
                                    }
                                }

                            }
                        }
                        else if(tokenRes == QXmlStreamReader::EndElement)
                        {
                            if(xml.name() == "response")//回应结果读取完成
                            {
                                break;
                            }
                        }
                    }
                }
                else if(nameStr == QString("sign"))//支付宝返回的校验码
                {

                }
                else if(nameStr == QString("sign_type"))//支付宝返回的校验码类型 固定MD5如果不是则出错
                {
                    if(xml.readElementText() != QString("MD5"))
                    {
                        qDebug()<<"支付宝校验码类型不为MD5";
                    }
                }
            }
            if(token == QXmlStreamReader::EndElement)
            {
                qDebug()<<"QXmlStreamReader::EndElement:"<<xml.name();

            }

            if(token == QXmlStreamReader::EndDocument)
            {
                qDebug()<<"QXmlStreamReader::EndDocument:"<<xml.name();

            }
        }

        xml.clear();


    }
    else
    {
        qDebug()<<"reply err!!!!";
    }
}



QString AlipayAPI::buildRequest(const QMap<QString, QString> &mapArr)
{
    //过滤签名参数数组
    QMap<QString, QString> paraMap = filterPara(mapArr);

    //获得签名结果
    QString mysign = buildRequestMysign(paraMap);
    //签名结果与签名方式加入请求提交参数组中
    paraMap.insert("sign",mysign);
    paraMap.insert("sign_type","MD5");

    //把参数组中所有元素，按照“参数=参数值”的模式用“&”字符拼接成字符串
    QString requestDataStr = createLinkString(paraMap);

    QByteArray requestDataArr = requestDataStr.toUtf8();

    //构造请求地址
    QString strUrl = aliConfig-> gatewayStr + "_input_charset=" + aliConfig->charset;

    QNetworkRequest network_request;
    network_request.setHeader(QNetworkRequest::ContentTypeHeader,"application/x-www-form-urlencoded");
    network_request.setHeader(QNetworkRequest::ContentLengthHeader, requestDataArr.length());
    network_request.setUrl(QUrl(strUrl));

    network_man->post(network_request,requestDataArr);
    qDebug()<<"buildRequest:"<<requestDataArr;

    return "";
}


//添加MD5校验
QString AlipayAPI::buildRequestMysign(const QMap<QString, QString> &mapArr)
{
    QString preStr = createLinkString(mapArr);
    preStr += aliConfig-> key;
     //默认 MD5校验
    QString mysign = "";
    QByteArray bb;
    bb = QCryptographicHash::hash(preStr.toUtf8(),QCryptographicHash::Md5 );
    mysign.append(bb.toHex());
    return mysign;
}





QString AlipayAPI::createLinkString(const QMap<QString, QString> &mapArr)
{
    QString str = "";
    QMap<QString,QString>::const_iterator imap;
    for(imap = mapArr.constBegin();imap != mapArr.constEnd();imap++)
    {
        str += QString("%1=%2&").arg(imap.key()).arg(imap.value());
    }
    //去掉最後一個&字符
    int len = str.length();
    if(len > 0)
        str.remove(len-1,1);
    return str;
}



// <summary>
// 除去数组中的空值和签名参数并以字母a到z的顺序排序
// </summary>
// <param name="dicArrayPre">过滤前的参数组</param>
// <returns>过滤后的参数组</returns>
QMap<QString, QString> AlipayAPI::filterPara(const QMap<QString, QString> &mapArr)
{
   QMap<QString, QString>  map;
   QMap<QString,QString>::const_iterator imap;
   for(imap = mapArr.constBegin();imap != mapArr.constEnd();imap++)
   {
       if (imap.key().toLower() != "sign" && imap.key().toLower() != "sign_type"
               && imap.value() != "" && imap.value() != NULL)
       {
           map.insert(imap.key(),imap.value());
       }
   }

   return map;
}



//开始交易请求生成二维码
void AlipayAPI::tradBegin()
{
    qDebug()<<"AlipayAPI:"<<trUtf8("当前线程:")<<QThread::currentThread();

    QMap<QString,QString> map;
    //接口名称
    str_cur_ali_type = aliConfig->str_precreate;
    map.insert("service",aliConfig->str_precreate);//统一预下单接口
    map.insert("partner",aliConfig->partner);//支付宝 PID号
    map.insert("seller_email", aliConfig->seller_email);//卖家支付宝帐户
    map.insert("_input_charset",aliConfig->charset.toLower());//编码
    map.insert("product_code","QR_CODE_OFFLINE");//二维码
    map.insert("total_fee","0.1");//订单总金额
    QString dateStr = QDateTime::currentDateTime().toString("yyyyMMddHHmmsszzz");
    map.insert("out_trade_no",dateStr);//商户网站唯一订单号
    str_cur_ali_trade_no = dateStr;
    map.insert("subject","订单下载");

    Json::Value jsonObj;
    Json::Value jsonArr;
    jsonObj["goodsName"] = trUtf8("不知名矿泉水").toStdString();
    jsonObj["quantity"] = "1";
    jsonObj["price"] = "0.1";
    jsonArr.append(jsonObj);
    QString jsonStr = QString::fromStdString(jsonArr.toStyledString());
    map.insert("goods_detail",jsonStr.toUtf8());
    qDebug()<<"jsonArr:"<<jsonStr.toUtf8();


    buildRequest(map);

}


