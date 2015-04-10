import QtQuick 1.1
import "../custom" as Custom
import "../trade" as Trade
Custom.VMWidget{
    id:mtMainTainPagRect
    anchors.fill:parent
    signal sqlActionSignal(variant type,variant obj)
    property Item curPage: mtMainTainPage
    property Item lastPage: mtMainTainPage
    property Item  goodsListItem:null
    onVisibleChanged: {
        if(visible == true){
            console.log("维护主页面显示:" + goodsListItem)
            //mtTradeManagePage.mtTrade_productCreate(goodsListItem);
            vmPageSwitch(mtMainTainPage);
        }
        else{
            mtTradeManagePage.mtTrade_productClear();
        }
    }
    //1.系统主页面
    Rectangle{
        id:mtMainTainPage
        property string datatime: "2015-01-02 12:12:12"
        anchors.fill: parent
        visible: true
        // 标题栏
        Rectangle{
            id:rect_title
            width: parent.width
            height: parent.height * 0.2
            anchors.top: parent.top
            anchors.topMargin: 10
            Column{
                anchors.fill: parent
                spacing: 15
                Text {
                    id: sys_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("系统维护")
                    font{
                        bold: true
                        pixelSize: 20
                    }
                }
                Text {
                    id: sys_time_text
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font{
                        bold: true
                        pixelSize: 16
                    }
                    text: qsTr("系统时间:") + mtMainTainPage.datatime
                }
                Timer {
                    interval: 500; running: true; repeat: true;
                    onTriggered: {
                        mtMainTainPage.datatime = Qt.formatDateTime(new Date(),"yyyy-MM-dd HH:mm:ss")
                    }
                }
            }
        }
        //维护工具栏
        Rectangle{
            width: parent.width
            height: parent.height * 0.5
            anchors.top: rect_title.bottom
            Grid{
                anchors.centerIn: parent
                spacing: 10
                columns: 3
                MTButton{
                    id:mtMainBar
                    button_text: qsTr("商品管理")
                    onButton_clicked: {
                        vmPageSwitch(mtMainTainPage)
                    }
                }
                MTButton{
                    button_text: qsTr("货道管理")
                    onButton_clicked: {
                        vmPageSwitch(mtMainTainPage)
                    }
                }
                MTButton{
                    id:mtTradeBar
                    button_text: qsTr("交易管理")
                    onButton_clicked: {
                        vmPageSwitch(mtTradeManagePage);
                        mtTradeManagePage.mtTradeSelectPage(99);
                    }
                }
                MTButton{
                    button_text: qsTr("操作日志")
                    onButton_clicked: {
                        vmPageSwitch(mTSystemManagePage)
                    }
                }
                MTButton{
                    id:mtProductBar
                    button_text: qsTr("设备管理")
                    onButton_clicked: {
                        vmPageSwitch(mTDeviceManagePage)
                    }
                }
                MTButton{
                    id:mtTradeBar2
                    button_text: qsTr("系统设置")
                    onButton_clicked: {
                        vmPageSwitch(mTSystemManagePage)
                    }
                }

            }
        }


    }





    //页面切换函数
    function vmPageSwitch(page){
        mtMainTainPagRect.lastPage = mtMainTainPagRect.curPage
        mtMainTainPagRect.curPage = page
        mtMainTainPagRect.lastPage.visible = false
        mtMainTainPagRect.curPage.visible = true

    }



    function sqlActionSlot(type,obj){
        console.log("后台维护操作SQL:" + "type=" + type + " obj=" + obj);

        mtTradeManagePage.columnPage.columnCreate(obj)
    }


}

