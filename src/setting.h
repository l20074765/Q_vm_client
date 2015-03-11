#ifndef SETTING_H
#define SETTING_H

#include <QObject>


class Setting : public QObject
{
    Q_OBJECT
public:
    explicit Setting(QObject *parent = 0);
    ~Setting();

    bool isQmlDebug(){return qmlDebug;}
    QString getVmPort(){return vmPort;}
signals:

public slots:

private:
    bool qmlDebug;
    QString vmPort;
};




extern Setting vmConfig;

#endif // SETTING_H
