#ifndef QQRENCODE_H
#define QQRENCODE_H

#include <QObject>
#include "qrencode.h"

class QPainter;
class QQrencode : public QObject
{
    Q_OBJECT
public:
    explicit QQrencode(QObject *parent = 0);
    ~QQrencode();


    static void draw_QRcode(QPainter *painter,const qreal w,const QString &text);
    static void draw_QRcodePix(const QString &text,qreal w,const QString &fileName);
signals:

public slots:
};

#endif // QQRENCODE_H
