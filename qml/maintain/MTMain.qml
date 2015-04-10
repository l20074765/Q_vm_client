import QtQuick 1.1
import "../custom" as Custom
import "../trade" as Trade
import "MainTain.js" as MainTainJs
Custom.VMWidget{
    id:rect_mainTain
    anchors.fill:parent
    z:3
    signal sqlActionSignal(variant type,variant obj)
    property Item  goodsListItem:null
    property MTProductPage productPage:null
    property MTColumnPage columnPage:null
    property MTSystemManagePage systemManagePage: null
    property MTDeviceManagePage deviceManagePage: null
    property MTTradeManagePage tradeManagePage: null

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
                        if(productPage == null){
                           productPage =  MainTainJs.loadComponent(rect_mainTain,"MTProductPage.qml");
                            for(var i = 0;i < 1000;i++){
                                productPage.vmCreateProduct();
                            }
                        }
                        productPage.visible = true;
                    }
                }
                MTButton{
                    button_text: qsTr("货道管理")
                    onButton_clicked: {
                        if(columnPage == null){
                           columnPage =  MainTainJs.loadComponent(rect_mainTain,"MTColumnPage.qml");
                        }
                        columnPage.visible = true;
                    }
                }
                MTButton{
                    id:mtTradeBar
                    button_text: qsTr("交易管理")
                    onButton_clicked: {
                        if(tradeManagePage == null){
                           tradeManagePage =  MainTainJs.loadComponent(rect_mainTain,"MTTradeManagePage.qml");
                        }
                        tradeManagePage.visible = true;
                    }
                }
                MTButton{
                    button_text: qsTr("操作日志")
                    onButton_clicked: {
                        //vmPageSwitch(mTSystemManagePage)
                    }
                }
                MTButton{
                    id:mtProductBar
                    button_text: qsTr("设备管理")
                    onButton_clicked: {
                        if(deviceManagePage == null){
                           deviceManagePage =  MainTainJs.loadComponent(rect_mainTain,"MTDeviceManagePage.qml");
                        }
                        deviceManagePage.visible = true;
                    }
                }
                MTButton{
                    id:mtTradeBar2
                    button_text: qsTr("系统设置")
                    onButton_clicked: {
                        if(systemManagePage == null){
                           systemManagePage =  MainTainJs.loadComponent(rect_mainTain,"MTSystemManagePage.qml");
                        }
                        systemManagePage.visible = true;
                    }
                }

            }
        }


    }


    function sqlActionSlot(type,obj){
        console.log("后台维护操作SQL:" + "type=" + type + " obj=" + obj);

        mtTradeManagePage.columnPage.columnCreate(obj)
    }


}

