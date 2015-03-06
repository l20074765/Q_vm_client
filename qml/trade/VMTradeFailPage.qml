import QtQuick 1.1
import "../custom" as Custom
Custom.VMWidget {
    anchors.fill: parent
    signal back_clicked()


    onVisibleChanged: {
        if(visible == true){
           title_bar.title_timer_set(1);
        }
        else{
            title_bar.title_timer_set(0);
        }
    }

    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * parent.titleHR
        anchors{top:parent.top}
        onRemain_timer_timeout: {
            back_clicked();
        }
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
            width: parent.width
            height: parent.height * 0.3
            anchors{
                top:parent.top
                topMargin: 20
            }
            Text{
                text:"出货失败\n"
                font.bold: true
                font.pixelSize: parent.width * 0.1
            }
        }

        Image {
            id: tradeover_image
            width: 140
            height: 46
            anchors{
                top:text_edit.bottom
                topMargin: 20
                horizontalCenter: parent.horizontalCenter

            }
            source: "../../images/tool/js-2.png"
            fillMode: Image.PreserveAspectCrop
            clip: true

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    back_clicked();
                }
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
            back_clicked()
        }
    }
}

