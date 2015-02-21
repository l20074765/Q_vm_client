#include "custom.h"

Custom::Custom(QObject *parent) : QObject(parent)
{

}

Custom::~Custom()
{

}




QString Custom::tr_c(const char *text)
{
    QString str = QString::fromUtf8(text);
    return str;
}
