#include "qqrencode.h"
#include <QPainter>
QQrencode::QQrencode(QObject *parent) : QObject(parent)
{

}

QQrencode::~QQrencode()
{

}


//绘制二维码图片接口 采用qt库
void QQrencode::draw_QRcode(QPainter *painter,const qreal w,const QString &text)
{
    if(painter == NULL) return;

    //QRcode_encodeString 是生成带纯带字符串的二维码
   // QRcode *qrcode = QRcode_encodeString(text.toStdString().c_str(),
    //                             2, QR_ECLEVEL_L, QR_MODE_8, 0);

    //QRcode_encodeData 是生成带数据的二维码
    QRcode *qrcode = QRcode_encodeData(w,(unsigned char *)text.toUtf8().data(),3,QR_ECLEVEL_M);
    if(!qrcode)
        return;

    //背景色 和 前景色
    QColor bgColor(Qt::white);
    bgColor.setAlphaF(0);

    QColor fgColor(Qt::black);
    QColor penColor(Qt::blue);
    QPen pen;
    pen.setColor(penColor);
    pen.setJoinStyle(Qt::RoundJoin);
    pen.setCapStyle(Qt::RoundCap);
    pen.setStyle(Qt::SolidLine);
    pen.setWidthF(2);
    QBrush brush(Qt::SolidPattern);
    brush.setColor(bgColor);
    painter->setBrush(Qt::NoBrush);
    painter->setOpacity(0);
    QRectF rectf(0,0,w,w);
    painter->setPen(pen);
    painter->setRenderHint(QPainter::Antialiasing,true);
    painter->drawRoundRect(rectf,30.1,30.1);

    qreal qw = w * 0.85;
    QRectF rectq(rectf.x() + (rectf.width() - qw) / 2,
                rectf.y() + (rectf.width() - qw) / 2,
                qw,qw);
    painter->setRenderHint(QPainter::Antialiasing,false);
    painter->setPen(Qt::NoPen);
    painter->setBrush(fgColor);
    painter->setOpacity(1);
    int s = qrcode->width > 0 ? qrcode->width : 1;
    qreal scale = rectq.width() / s;
    char *p = (char *)qrcode->data;
    for(int y = 0; y < s;y++)
    {
        for(int x = 0;x < s;x++)
        {
             if(*p & 1)
             {
                QRectF rect2(x*scale + rectq.x(),y*scale + rectq.y(),scale,scale);
                painter->drawRect(rect2);
             }
             p++;
        }
    }
    QRcode_free(qrcode);

#if 0
    QPixmap pe1(":/images/alipay/alipay.png");
    qreal ps = w * 0.16;
    QPixmap tmp =pe1.scaled(ps,ps,Qt::IgnoreAspectRatio);
    QRectF target(rectq.x() + (rectq.width()-ps)/2,
                  rectq.y() + (rectq.height()-ps)/2, ps, ps);
    QRectF pe1Rect(0,0,ps,ps);
    painter->setBrush(bgColor);
    painter->setPen(Qt::NoPen);
    painter->drawPixmap(target,tmp,pe1Rect);
#endif
}



void QQrencode::draw_QRcodePix(const QString &text, qreal w,const QString &fileName)
{
    QPixmap pix(w,w);
    QPainter p(&pix);
    draw_QRcode(&p,w,text);
    p.end();
    pix.save(fileName);


}

