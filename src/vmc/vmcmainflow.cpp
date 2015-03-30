#include "vmcmainflow.h"
#include <QtDebug>
#include "orderlist.h"

VmcMainFlow  *mainThis = NULL;//定义全局main指针


VmcMainFlow::VmcMainFlow(QObject *parent, const QString &portName)
    :QObject(parent),portName(portName)
{

    init();
    lib_ev.setFileName("libs/EVprotocol");
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
    vmcObj =  new VmcObj(this);
    connect(this,SIGNAL(EV_callBackSignal(quint8,const void*)),
            this,SLOT(EV_callBackSlot(quint8,const void*)),Qt::QueuedConnection);
    setVmcState(EV_STATE_DISCONNECT);

}


void VmcMainFlow::setVmcState(const int state)
{
    qDebug()<<"VmcMainFlow::setVmcState"<<state;
    this->vmcState = state;
    emit ActionSignal(QVariant((int)VMC_ACTION_STATE),QVariant((int)state));
}

void VmcMainFlow::ActionSlot(QVariant type,QVariant obj)
{
    qDebug()<<"VmcMainFlow::vmcActionSlot type="<<type<<" obj="<<obj;
    if(type == VMC_ACTION_TRADE){
        OrderList *orderList = qobject_cast<OrderList *>(obj.value<QObject *>());
        if(orderList == NULL){
            qDebug()<<"VmcMainFlow::vmcActionSlot  orderList == NULL";
            return;
        }
        this->orderList = orderList;
        orderIndex = 0;
        orderColumnIndex = 0;
        tradeFormOrder();

    }

}


void VmcMainFlow::tradeFormOrder()
{
    if(orderList->list.count() <= orderIndex){
        qWarning()<<"VmcMainFlow::tradeFormOrder---orderList->list.count() < orderIndex"
                 <<"orderList->list.count()="<<orderList->list.count()
                <<" orderIndex="<<orderIndex;
        return;
    }
    Order *order = orderList->list.at(orderIndex);

    if(order == NULL || order->columnList.count() <= orderColumnIndex){
        qWarning()<<"VmcMainFlow::tradeFormOrder---order->columnList.count() <= orderColumnIndex";
        return;
    }

    for(int i = orderColumnIndex;i < order->columnList.count();i++){
        SqlColumn *column = order->columnList.at(i);
        qDebug()<<tr("出货货道:")<<column->id;
        if(column->state == 1 || column->remain > 0){
            orderColumnIndex = i;
            vmcTrade(column->bin,column->column,1,0);//发送出货命令
            return;
        }
        else
            continue;
    }

}


void VmcMainFlow::tradeResultToOrder(int res)
{
    if(res == 0){
        qWarning()<<"VmcMainFlow::tradeResultToOrder---res == 0";
        QVariant var((int)VMC_ACTION_TRADE_FAIL);
        emit ActionSignal(var,0);
        return;
    }
    //出货成功继续出货
    Order *order = orderList->list.at(orderIndex);
    SqlColumn *column = order->columnList.at(orderColumnIndex);
    if(order->buyNum)
        order->buyNum--;
    if(column->remain)
        column->remain--;

    //该商品还需出货
    if(order->buyNum){
        for(int i = orderColumnIndex;i < order->columnList.count();i++){
            SqlColumn *tempColumn = order->columnList.at(i);
            //该货道还有货继续出货
            if(tempColumn->remain){
                orderColumnIndex = i;
                vmcTrade(tempColumn->bin,tempColumn->column,1,0);
                break;
            }
        }
    }
    else{
        //一个商品购买完成
        if(orderIndex == (orderList->list.count() - 1))//出货完成
        {
            QVariant var((int)VMC_ACTION_TRADE_OK);
            emit ActionSignal(var,0);
        }
        else{
            orderIndex++;
            orderColumnIndex = 0;
            tradeFormOrder();
        }
    }
}


void VmcMainFlow::EV_callBackSlot(const quint8 type,const void *ptr)
{
    qDebug()<<"VmcMainFlow:EV_back type="<<QString("%1").arg(type,2,16,QLatin1Char('0')).toUpper();
    if(type == EV_STATE_RPT)
    {
        ST_STATE *state = (ST_STATE *)ptr;
        int s = state->vmcState;
        if(getVmcState() != s)
        {
            setVmcState(s);
        }
    }
    else if(type == EV_ENTER_MANTAIN)//
    {
        if(getVmcState() != EV_STATE_MANTAIN)
        {
           setVmcState(EV_STATE_MANTAIN);
        }

    }
    else if(type == EV_EXIT_MANTAIN)//推出维护
    {
        setVmcState(EV_STATE_FAULT);    
    }
    else if(type == EV_COLUMN_RPT)
    {
        ST_COLUMN *q,*p;
        ST_COLUMN_RPT *column = (ST_COLUMN_RPT *)ptr;
        if(column == NULL) return;
        p = &column->head;
        //遍历链表
        while(p->next != NULL)
        {
            q = p->next;
            qDebug()<<"no=%d"<<q->no<<"state=%d"<<q->state;
            p = q;

        }
        qDebug()<<"EV_COLUMN_RPT";
       // QVariant var;
       // var.setValue((int)EV_STATE_FAULT);
       // emit vmcActionSignal(VMC_ACTION_STATE,var);
    }
    else if(type == EV_OFFLINE)//离线
    {
        setVmcState(EV_STATE_FAULT);
    }
    else if(type == EV_TRADE_RPT)//出货结果上报
    {
        ST_TRADE *trade = (ST_TRADE *)ptr;
        if(trade == NULL){
           // emit ActionSignal(VMC_ACTION_TRADE_FAIL,NULL);
            tradeResultToOrder(0);
        }
        else{
            if(trade->result != 0){
                tradeResultToOrder(0);
               // emit ActionSignal(VMC_ACTION_TRADE_FAIL,NULL);
            }
            else{
                tradeResultToOrder(1);
            }
        }
    }

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


int VmcMainFlow::vmcTrade(int cabinet, int column, int type, long cost)
{
    qDebug()<<tr("出货命令:")<<"cabinet="<<cabinet<<" column="<<column;
    typedef int (*EV_trade)(int , int , int , long );
    EV_trade trade = (EV_trade)lib_ev.resolve("EV_trade");
    if(trade)
    {
        return trade(cabinet,column,type,cost);
    }
    else
        return 0;
}

int VmcMainFlow::vmcGetColumn(int cabinet)
{
    typedef int    (*EV_getColumn)(int);
    EV_getColumn getColumn = (EV_getColumn)lib_ev.resolve("EV_getColumn");
    if(getColumn)
        return getColumn(cabinet);
    else
        return 0;

}

