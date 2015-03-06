#ifndef QRENPIXWIDGET_H
#define QRENPIXWIDGET_H

#include <QWidget>

class QrenPixWidget : public QWidget
{
    Q_OBJECT
public:
    explicit QrenPixWidget(QWidget *parent = 0);
    ~QrenPixWidget();
    QString pic;
signals:

public slots:
protected:
    void paintEvent(QPaintEvent *v);

private:

};

#endif // QRENPIXWIDGET_H
