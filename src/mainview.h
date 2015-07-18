#ifndef MAINVIEW_H
#define MAINVIEW_H

#include <QObject>
#include "mainflow.h"
#include<QApplication>


class QDeclarativeView;
class QDeclarativeContext;
class QDeclarativeItem;
class QGraphicsObject;
class QThread;

class MainView : public QObject
{
    Q_OBJECT
public:
    explicit MainView(QObject *parent = 0);
    ~MainView();

    void setFont(const QFont &font);
    void show();
signals:
    void qmlActionSignal(QVariant type,QVariant obj);
    void vmActionSignal(QVariant type,QVariant obj);
public slots:
    void qmlActionSlot(QVariant type,QVariant obj);
    void vmActionSlot(QVariant type,QVariant obj);
    QString appVersion();
private:
    QDeclarativeItem *mainItem;
    QDeclarativeContext *context;
    QDeclarativeView *view;

    //后端主线程
    MainFlow *mainFlow;
    QThread *mainThread;
};

#endif // MAINVIEW_H
