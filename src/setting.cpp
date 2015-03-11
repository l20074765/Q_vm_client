#include "setting.h"
#include <QSettings>

Setting vmConfig;


Setting::Setting(QObject *parent) : QObject(parent)
{
    QSettings *read = new QSettings("config.ini",QSettings::IniFormat);
    bool ok;
    qmlDebug = read->value("CONFIG/QmlDebug").toInt(&ok);
    vmPort = read->value("CONFIG/VmPort").toString();
    if(vmPort.isEmpty())
        vmPort = "COM1";
    delete read;
}

Setting::~Setting()
{

}

