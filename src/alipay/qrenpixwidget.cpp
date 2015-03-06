#include "qrenpixwidget.h"
#include <QPainter>
#include <QPixmap>
#include <QtDebug>
#include "qqrencode.h"
QrenPixWidget::QrenPixWidget(QWidget *parent) : QWidget(parent)
{
    setWindowFlags(Qt::FramelessWindowHint);
}

QrenPixWidget::~QrenPixWidget()
{

}


void QrenPixWidget::paintEvent(QPaintEvent *v)
{
    QPainter painter(this);
    painter.setBrush(QColor(Qt::white));
    painter.setPen(Qt::NoPen);
    QRect rect = this->rect();
    qDebug()<<"QrenPixWidget::paintEvent"<<rect<<pic;
    QQrencode::draw_QRcode(&painter,rect.width(),pic);
}

