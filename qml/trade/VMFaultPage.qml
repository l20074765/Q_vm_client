import QtQuick 1.0
import "../custom" as Custom


//故障界面
Custom.VMWidget {
    id:vmFault_page
    anchors.fill: parent
    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * parent.titleHR
        anchors{top:parent.top}
    }

    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * parent.rectHR
        anchors{
            top:title_bar.bottom
        }

        Text{
            id:test1
            width: parent.width
            height: parent.height * 0.05

            anchors{
                top:parent.top
                topMargin: 10
            }

            horizontalAlignment: Text.AlignHCenter
            color: "darkred"
            font.bold: true
            font.pixelSize: parent.width * 0.08
            text:qsTr("本机故障")
        }
        Text{
            id:test2
            width: parent.width
            height: parent.height * 0.05
            anchors{
                top:test1.bottom
                topMargin: 10
            }
            horizontalAlignment: Text.AlignHCenter
            color: "red"
            font.bold: true
            font.pixelSize: parent.width * 0.06
            text:qsTr("暂停服务")
        }

    }

    //状态栏区域
    Custom.VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height * parent.statusHR
        anchors{top:main_rect.bottom}
        onStatus_back_clicked: {
            //执行返回按钮
        }
    }


    function pageShow(){ //页面切换
        show();
    }

    function pageHide(){  //页面隐藏
        hide();
    }


}

