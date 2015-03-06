import QtQuick 1.1
import "../custom" as Custom

Custom.VMWidget{
    id:mtMainTainPagRect
    anchors.fill:parent
    property Item curPage: mtMainTainPage
    property Item lastPage: mtMainTainPage
    onVisibleChanged: {
        if(visible == true){
            vmPageSwitch(mtMainTainPage)
        }
    }

    //主界面
    Rectangle{
        id:mtMainTain
        property string datatime: "2015-01-02 12:12:12"
        width: parent.width
        height: parent.height * 0.92
        anchors.top:parent.top
        //1.系统主页面
        MTMainTainPage{
            id:mtMainTainPage
            anchors.fill: parent
            visible: true
        }

        //2.交易管理
        MTTradeManagePage{
            id:mtTradeManagePage
            anchors.fill: parent
        }

        //3.设备管理
        MTDeviceManagePage{
            id:mTDeviceManagePage
            anchors.fill: parent
        }

        //4.系统设置
        MTSystemManagePage{
            id:mTSystemManagePage
            anchors.fill: parent
        }

    }


    Rectangle{
        id:mtToolBar
        anchors{
            bottom: parent.bottom
        }
        width: parent.width
        height: parent.height * 0.08
        color: "white"

        MTButton{
            id:mtMainBar
            anchors.left: parent.left
            anchors.bottom: parent.bottom
            width: parent.width * 0.25
            height: parent.height
            button_text: qsTr("维护首页")
            onButton_clicked: {
                vmPageSwitch(mtMainTainPage)
            }
        }

        MTButton{
            id:mtTradeBar
            anchors.left: mtMainBar.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.25
            height: parent.height
            button_text: qsTr("交易管理")
            onButton_clicked: {
                vmPageSwitch(mtTradeManagePage)
            }
        }
        MTButton{
            id:mtProductBar
            anchors.left: mtTradeBar.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.25
            height: parent.height
            button_text: qsTr("设备管理")
            onButton_clicked: {
                vmPageSwitch(mTDeviceManagePage)
            }
        }
        MTButton{
            id:mtTradeBar2
            anchors.left: mtProductBar.right
            anchors.bottom: parent.bottom
            width: parent.width * 0.25
            height: parent.height
            button_text: qsTr("系统设置")
            onButton_clicked: {
                vmPageSwitch(mTSystemManagePage)
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


}

