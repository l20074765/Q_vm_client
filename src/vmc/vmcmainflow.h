#ifndef VMCMAINFLOW_H
#define VMCMAINFLOW_H

#include <QObject>
#include <QLibrary>
#include "EVprotocol.h"
#include "vmcobj.h"
#include <QVariant>

class OrderList;

class VmcMainFlow : public QObject
{
    Q_OBJECT

    Q_ENUMS(VmcEnumType)
public:
    explicit VmcMainFlow(QObject *parent = 0,const QString &portName = "COM1");
    ~VmcMainFlow();

    enum VmcEnumType{
        VMC_ACTION_STATE = 0, //状态变化
        VMC_ACTION_TRADE,
        VMC_ACTION_TRADE_FAIL,
        VMC_ACTION_TRADE_OK
    };

    void init();
    void EV_fun(int type,const void *ptr);
    void vmcStart();
    int  vmcTrade(int cabinet,int column,int type,long cost);
    int  vmcGetColumn(int cabinet);


    void setVmcState(const int state);
    int getVmcState()const {return vmcState;}
signals:
    void EV_callBackSignal(const quint8 type,const void *ptr);


    void ActionSignal(QVariant type,QVariant obj);
public slots:
    void EV_callBackSlot(const quint8 type,const void *ptr);

    void ActionSlot(QVariant type,QVariant obj);

    void EV_start_slot();
private:
    QLibrary lib_ev;
    QString portName;
    typedef void  (__stdcall *EV_CALLBACK_HANDLE)(int,const void *);
    static void  __stdcall EV_callBack(int type,const void *ptr);


    int vmcState;



    VmcObj *vmcObj;


    int orderIndex;
    int orderColumnIndex;




    OrderList *orderList;
    void tradeFormOrder();
    void tradeResultToOrder(int res);

};

#endif // VMCMAINFLOW_H
