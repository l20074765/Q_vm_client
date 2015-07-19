import QtQuick 1.1
import "../custom" as Custom
import "../trade" as Trade
import "MainTain.js" as MainTainJs
Custom.VMWidget{
    id:rect_mainTain
    anchors.fill:parent
    z:3
    signal sqlActionSignal(variant type,variant obj)
    property Item goodsListItem:null
    property Item productPage:null
    property Item columnPage:null
    property Item systemManagePage: null
    property Item deviceManagePage: null
    property Item tradeManagePage: null
    property string version: ""
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
            height: parent.height * 0.5
            anchors.top: parent.top
            anchors.topMargin: 10
            Column{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                spacing: height * 0.005
                Text {
                    id: sys_text
                    width: parent.width
                    height: parent.height * 0.15
                    horizontalAlignment: Text.AlignHCenter
                    text: qsTr("系统维护")
                    font{
                        bold: true
                        pixelSize:  (height < width) ? height * 0.6 : width * 0.6
                    }
                }
                Text {
                    id: sys_time_text
                    width: parent.width
                    height: parent.height * 0.1
                    horizontalAlignment: Text.AlignHCenter
                    font{
                        bold: true
                        pixelSize: (height < width) ? height * 0.4 : width * 0.4
                    }
                    text: qsTr("系统时间:") + mtMainTainPage.datatime
                }
                Text {
                    id: sys_text_version
                    width: parent.width
                    height: parent.height * 0.08
                    horizontalAlignment: Text.AlignHCenter
                    font{
                        bold: false
                        pixelSize: (height < width) ? height * 0.4 : width * 0.4
                    }
                    text: "系统版本:" + version
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
                width: parent.width * 0.8
                height: parent.height * 0.8
                anchors.horizontalCenter: parent.horizontalCenter
                //anchors.: parent.verticalCenter
                spacing: 10
                columns: 3

                MTButton{
                    id:mtMainBar
                    width: parent.width * 0.3
                    height: parent.height *  0.35
                    button_text: qsTr("商品管理")
                    onButton_clicked: {
                        if(productPage == null){
                           productPage =  MainTainJs.loadComponent(rect_mainTain,"MTProductPage.qml"); 
                        }
                        if(productPage){
                            productPage.productFlush();
                            productPage.visible = true;
                        }
                    }
                }
                MTButton{
                    width: parent.width * 0.3
                    height: parent.height *  0.35
                    button_text: qsTr("货道管理")
                    onButton_clicked: {
                        if(columnPage == null){
                           columnPage =  MainTainJs.loadComponent(rect_mainTain,"MTColumnPage.qml");
                           vm_main.qmlMainSignal.connect(columnPage.loadingFinished);
                        }
                        columnPage.flush();
                        columnPage.visible = true;
                    }
                }
                MTButton{
                    id:mtTradeBar
                    width: parent.width * 0.3
                    height: parent.height *  0.35
                    button_text: qsTr("交易管理")
                    onButton_clicked: {
                        if(tradeManagePage == null){
                           tradeManagePage =  MainTainJs.loadComponent(rect_mainTain,"MTTradeManagePage.qml");
                        }
                        tradeManagePage.visible = true;
                    }
                }
                MTButton{
                    width: parent.width * 0.3
                    height: parent.height *  0.35
                    button_text: qsTr("操作日志")
                    onButton_clicked: {
                        //vmPageSwitch(mTSystemManagePage)
                    }
                }
                MTButton{
                    id:mtProductBar
                    width: parent.width * 0.3
                    height: parent.height *  0.35
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
                    width: parent.width * 0.3
                    height: parent.height *  0.35
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
    }


}

