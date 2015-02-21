


#ifndef _EVprotocol_H_
#define _EVprotocol_H_

#ifdef __cplusplus
extern "C" {
#endif

#ifdef  EV_WIN32
#define EV_EXPORT __declspec(dllexport)
#define EV_API  __stdcall //注意在win32平台下统一采用stdcall标准调用方式
#elif   EV_UNIX
#define EV_API
#define EV_EXPORT __declspec(dllexport)
#else
#define EV_API
#define EV_EXPORT
#endif



#define EV_INITING          0xA4    //表示已于VMC连通,正在与VMC进行初始化操作
#define EV_RESTART          0xA5    //表示VMC控制板重新启动标志
#define EV_OFFLINE          0xA6    //表示与VMC主控板断开连接,通信故障
#define EV_ONLINE           0xA7    //表示与VMC通信建立完成,PC可以主动发送命令
#define EV_SETUP_REQ        0x90    //注册请求
#define EV_SETUP_RPT 		0x05    //注册结果返回,返回机器设备的整体信息.
#define EV_REQUEST_FAIL     0xAB    //当PC发送命令后,返回此条消息表明指令发送失败




#define EV_NA               0x00    //无请求
#define EV_INFO_REQ 		0x8C
#define EV_INFO_RPT 		0x11
#define EV_ACK_PC           0x80
#define EV_NAK_PC           0x81 //PC回应NAK
#define EV_ACK_VM           0x01
#define EV_NAK_VM           0x02 //VMC拒绝PC请求
#define EV_POLL             0x03
#define EV_PAYIN_RPT        0x06  //投币报告
#define EV_COLUMN_REQ       0x8A  //获取货道
#define EV_COLUMN_RPT       0x0E  //货道报告
#define EV_TRADE_REQ        0x83
#define EV_TRADE_RPT        0x08
#define EV_ACTION_RPT       0x0B
#define EV_STATE_REQ        0x86
#define EV_STATE_RPT        0x0D
#define EV_BUTTON_RPT       0x0C
#define EV_CONTROL_REQ      0x85
#define EV_PAYOUT_REQ       0x89
#define EV_PAYOUT_RPT       0x07
#define EV_CONTROL_RPT      0xA0
#define EV_ACTION_REQ       0xA1
#define EV_ENTER_MANTAIN    0xA2
#define EV_EXIT_MANTAIN     0xA3
#define EV_TIMEOUT          0xA8


//目标机32位
typedef unsigned char       uint8;
typedef unsigned short      uint16;
typedef unsigned int        uint32;
typedef unsigned long       uint64;
typedef  char               int8;
typedef  short              int16;
typedef  int                int32;
typedef  long               int64;




typedef struct _st_cash_{
    uint8      recv_type;       //现金接收器类型
    uint32     recv_max_value;  //现金接收器上限
    uint32     recv_ch[8];      //现金接收器通道面值
    uint8      change_type;     //现金找零器类型
    uint32     change_ch[8];    //现金找零器通道面值
}ST_CASH;


typedef struct _st_card_{
    uint8 type;
}ST_CARD;


typedef struct _st_bin_{
    uint8 type;//0关闭 1弹簧 2老式升降机 3升降机+传送带 4升降机+弹簧
    uint8 addGoods;//补货方式 0手动 1自动
    uint8 goc;//0关闭出货确认  1开启
    uint8 light;//照明支持  0不支持 1支持
    uint8 hot;//加热支持 0不支持 1支持
    uint8 cool;//制冷支持 0不支持 1支持
    uint8 keyboard;//按键支持 0不支持 1支持
    uint8 compressor;// 压缩机支持 0不支持 1支持
}ST_BIN;


typedef struct _st_setup_{
    uint8       language;    //主控板语言版本 0中文 1英文
    uint8       payoutTime;  //超时退币  单位秒  255 表示不退币
    uint8       multBuy;     //多次购买
    uint8       forceBuy;    //强制购买
    uint8       humanSensor; //是否支持人体接近感应
    uint8       gameButton;  //是否支持游戏按键
    ST_CASH     bill;       //纸币器结构体
    ST_CASH     coin;       //硬币器结构体
    ST_CARD     card;       //读卡器结构体
    ST_BIN      bin;        //主柜结构体
    ST_BIN      subBin;     //副柜结构体
    /*以下是与上位机无关的信息*/
    uint8       vmRatio;     //VMC主控板比例因子 1表示分 10表示角  100表示元(上位机忽略)
}ST_SETUP;



#define PC_CMD_TIMEOUT  1   //PC发送请求超时
#define PC_CMD_NAK      2   //PC发送请求被VMC拒绝
#define PC_CMD_BUSY      3  //VMC忙状态，暂不接受PC另外请求
#define PC_CMD_FAULT      4 //VMC断开通信或者正在初始化，暂不接受PC另外请求
typedef struct _st_pc_req_{
    uint8 type; //VMC当前准备处理的请求类型
    uint8 err;  //请求失败的原因

}ST_PC_REQ;



typedef struct _st_trade_{
    uint8 cabinet;
    uint8 column;
    uint8 result;
    uint8 type;
    uint8 cost;
    uint32 remainAmount;
    uint8 remainCount;
}ST_TRADE;


//状态上报结构体
typedef struct _st_state_{
    uint8 vmcState;//VMC当前状态
    uint8 billState;
    uint8 coinState;
    uint8 cabinetState;
    uint8 billch[8];//纸币找零量
    uint8 coinch[8];//硬币找零量

}ST_STATE;



//投币金额上报
typedef struct _st_payin_rpt_{
    uint8   payin_type;//当前投币类型 0:硬币  1:纸币押钞 2:纸币器暂存 3:纸币器暂出
    uint32  payin_amount;//当前投币的面值 单位分
    uint32  reamin_amount;//当前用户投币余额 单位分
}ST_PAYIN_RPT;

//出币报告
typedef struct _st_payout_rpt_{
    uint8   payout_type;//当前出币的类型 0硬币出币 1纸币出币
    uint32  payout_amount;//当前实际退币金额 单位分
    uint32  reamin_amount;//退币后当前用户投币余额 单位分
}ST_PAYOUT_RPT;


//VMC当前状态
#define EV_STATE_DISCONNECT		0    //断开连接
#define EV_STATE_INITTING		1    //正在初始化
#define EV_STATE_NORMAL			2    //正常
#define EV_STATE_FAULT			3    //故障
#define EV_STATE_MANTAIN		4    //维护





#ifndef EV_ANDROID  //安卓平台下不导出这些接口


/*********************************************************************************************************
** Function name	:		EV_CALLBACK_HANDLE
** Descriptions		:		回调函数入口定义
** input parameters	:       type 回调回传的类型, ptr 回调回传的结构体参数
** output parameters:		无
** Returned value	:		无
*********************************************************************************************************/
typedef void (EV_API *EV_CALLBACK_HANDLE)(int type,const void *ptr);



/*********************************************************************************************************
** Function name	:		EV_vmcStart
** Descriptions		:		启动VMC服务程序
** input parameters	:       portName 串口号 例如"COM1", callBack 回调函数指针
** output parameters:		无
** Returned value	:		1成功  -1失败(串口打开失败)  0创建线程失败
*********************************************************************************************************/
EV_EXPORT int   EV_API  EV_vmcStart(char *portName,EV_CALLBACK_HANDLE callBack);


EV_EXPORT void  EV_API  EV_vmcStop();
EV_EXPORT int   EV_API  EV_trade(int cabinet,int column,int type,long cost);
EV_EXPORT int   EV_API  EV_payout(long value);
EV_EXPORT int   EV_API  EV_getStatus();
EV_EXPORT long  EV_API  EV_getRemainAmount();
EV_EXPORT int   EV_API  EV_bentoRegister(char *portName);
EV_EXPORT int   EV_API  EV_bentoOpen(int cabinet, int box);
EV_EXPORT int   EV_API  EV_bentoRelease();
EV_EXPORT int   EV_API  EV_bentoLight(int cabinet, int flag);
EV_EXPORT int   EV_API  EV_bentoCheck(int cabinet,char *msg);
EV_EXPORT int   EV_API  EV_cashControl(int flag);
EV_EXPORT int   EV_API  EV_cabinetControl(int cabinet, int dev, int flag);
EV_EXPORT int   EV_API  EV_setDate(const void *date);

#endif
#ifdef __cplusplus
}
#endif
#endif
