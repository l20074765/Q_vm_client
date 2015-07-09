#ifndef SETTING_H
#define SETTING_H

#include <QObject>
#include <QStringList>

class Setting : public QObject
{
    Q_OBJECT
public:
    explicit Setting(QObject *parent = 0);
    ~Setting();

    bool isQmlDebug(){return qmlDebug;}
    QString getVmPort(){return vmPort;}
    QString productImagePath();


signals:

public slots:

    bool createDir(const QString &filePath);
    QStringList getFilePicList(const QString &filePath);
    QString productPicPath();
    QString productDefaultPic();
private:
    bool qmlDebug;
    QString vmPort;
};




extern Setting vmConfig;

#endif // SETTING_H
