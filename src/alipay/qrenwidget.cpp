#include "qrenwidget.h"
#include <QtDebug>
QrenWidget::QrenWidget(QGraphicsItem *parent)
    : QGraphicsProxyWidget(parent)
{
    pixWidget = new QrenPixWidget();
    pixWidget->show();
    this->setWindowFlags(Qt::FramelessWindowHint);\
    this->setWidget(pixWidget);
}

QrenWidget::~QrenWidget()
{

}

void QrenWidget::setPix(QString text)
{
    qDebug()<<"QrenWidget::setPix"<<text;
    pixWidget->pic = text;
    pixWidget->update();
}

