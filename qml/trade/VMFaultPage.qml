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
        anchors{top:title_bar.bottom}
        //文本区
        TextEdit{
            id:text_edit
            anchors.fill: parent
            Text{
                text:"本机故障\n暂停服务"
                font.bold: true
                font.pixelSize: parent.width * 0.1
            }
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





}

