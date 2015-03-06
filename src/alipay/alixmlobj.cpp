#include "alixmlobj.h"

AliXmlObj::AliXmlObj(QObject *parent) : QObject(parent)
{
    isBackSuccess = false;
    isRequstSuccess = false;
    service.clear();
    qrencodeUrl.clear();

}

AliXmlObj::~AliXmlObj()
{

}

