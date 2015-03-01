import QtQuick 1.1
import "../custom" as Custom
//出货界面
Custom.VMWidget {




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
        Text {
            id: name
            font{
                bold: true
                pixelSize: 25
            }
            text: qsTr("付款成功") + "\n" + qsTr("正在出货")
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

