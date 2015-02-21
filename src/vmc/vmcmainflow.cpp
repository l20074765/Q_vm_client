#include "vmcmainflow.h"
#include <QtDebug>

VmcMainFlow  *mainThis = NULL;//定义全局main指针


VmcMainFlow::VmcMainFlow(QObject *parent, const QString &portName)
    :QObject(parent),portName(portName)
{

    init();
    lib_ev.setFileName("EVprotocol");
    if(lib_ev.load())
    {
        qDebug()<<"lib_ev Load OK..";
    }
    else
        qDebug()<<"lib_ev Load failed..";

}

VmcMainFlow::~VmcMainFlow()
{

}


void VmcMainFlow::init()
{
    mainThis = this;
    connect(this,SIGNAL(EV_callBackSignal(quint8,const void*)),
            this,SLOT(EV_callBackSlot(quint8,const void*)),Qt::QueuedConnection);

}

void VmcMainFlow::EV_callBackSlot(const quint8 type,const void *ptr)
{
    qDebug()<<"EV_back type="<<QString("%1").arg(type,2,16,QLatin1Char('0')).toUpper();

}

//注意次函数是在子线程调用，不能在这里做UI更新的操作
void VmcMainFlow::EV_fun(int type, const void *ptr)
{
    emit EV_callBackSignal(type,ptr);
}



void  __stdcall VmcMainFlow::EV_callBack(int type, const void *ptr)
{
    if(mainThis)
    {
        mainThis->EV_fun(type,ptr);
    }
}



void VmcMainFlow::vmcStart()
{
    EV_start_slot();
}

void VmcMainFlow::EV_start_slot()
{
    typedef int (*EV_vmcStart)(char *,EV_CALLBACK_HANDLE);
    EV_vmcStart vmcStart = (EV_vmcStart)lib_ev.resolve("EV_vmcStart");
    if(vmcStart)
    {
        QByteArray portArr = portName.toLatin1();
        int ret = vmcStart(portArr.data(),VmcMainFlow::EV_callBack);
        if(ret == -1)
        {
            qDebug()<<tr("Open serialport fail!");
        }
        qDebug()<<QString("EV started ok....");
        return;
    }
    qDebug()<<tr("Load dll failed!");
}
