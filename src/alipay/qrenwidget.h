#ifndef QRENWIDGET_H
#define QRENWIDGET_H

#include <QGraphicsProxyWidget>
#include "qrenpixwidget.h"
class QrenWidget : public QGraphicsProxyWidget
{
    Q_OBJECT
public:
    explicit QrenWidget(QGraphicsItem *parent = 0);
    ~QrenWidget();

signals:

public slots:
    void setPix(QString text);

private:
    QrenPixWidget *pixWidget;
};

#endif // QRENWIDGET_H
