#ifndef VMCOBJ_H
#define VMCOBJ_H

#include <QObject>

class VmcObj : public QObject
{
    Q_OBJECT
public:
    explicit VmcObj(QObject *parent = 0);
    ~VmcObj();



    int state;
signals:

public slots:
};

#endif // VMCOBJ_H
