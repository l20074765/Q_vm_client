#ifndef VMCMAINFLOW_H
#define VMCMAINFLOW_H

#include <QObject>
#include <QLibrary>
#include "EVprotocol.h"

class VmcMainFlow : public QObject
{
    Q_OBJECT
public:
    explicit VmcMainFlow(QObject *parent = 0,const QString &portName = "COM1");
    ~VmcMainFlow();

    void init();
    void EV_fun(int type,const void *ptr);
    void vmcStart();
signals:
    void EV_callBackSignal(const quint8 type,const void *ptr);

public slots:
    void EV_callBackSlot(const quint8 type,const void *ptr);


    void EV_start_slot();
private:
    QLibrary lib_ev;
    QString portName;
    typedef void  (__stdcall *EV_CALLBACK_HANDLE)(int,const void *);
    static void  __stdcall EV_callBack(int type,const void *ptr);







};

#endif // VMCMAINFLOW_H
