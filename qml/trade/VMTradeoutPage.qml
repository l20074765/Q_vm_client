import QtQuick 1.1
import "../custom" as Custom
//出货界面
Custom.VMWidget {
    property string resultStr: "正在出货"

    signal back_clicked()
    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * 0.05
        anchors{top:parent.top}
    }

    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.9
        anchors{top:title_bar.bottom}
        //文本区
        Text {
            id: pay_text
            width: parent.width
            height: parent.height * 0.4
            anchors.centerIn: parent
            font{
                bold: true
                pixelSize: 25
            }
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("付款成功") + "\n" + resultStr
        }


        Image {
            id: tradeover_image
            width: 140
            height: 46
            anchors{
                top:pay_text.bottom
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
        height: parent.height * 0.05
        anchors{top:main_rect.bottom}
        onStatus_back_clicked: {
            //执行返回按钮
        }
    }



}

