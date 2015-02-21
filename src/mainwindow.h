#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QDeclarativeView>
#include "mainobject.h"

class QDeclarativeContext;
class QDeclarativeItem;
class QGraphicsObject;

class MainWindow : public QDeclarativeView
{
    Q_OBJECT
public:
    explicit MainWindow(QWidget *parent = 0);
    ~MainWindow();


signals:

public slots:
    void setUiState(quint8 state);
    void qmlCreateProduct();
    void qmlDeleteProduct();
private:
    MainObject *mainObject;
    QDeclarativeItem *mainItem;
    QDeclarativeContext *context;



};

#endif // MAINWINDOW_H
