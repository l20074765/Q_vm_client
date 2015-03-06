#ifndef ALIXMLOBJ_H
#define ALIXMLOBJ_H

#include <QObject>

class AliXmlObj : public QObject
{
    Q_OBJECT
public:
    explicit AliXmlObj(QObject *parent = 0);
    ~AliXmlObj();


    bool isRequstSuccess;//是否请求成功
    bool isBackSuccess;//是否回应成功
    QString service;
    QString qrencodeUrl;
signals:

public slots:
};

#endif // ALIXMLOBJ_H
