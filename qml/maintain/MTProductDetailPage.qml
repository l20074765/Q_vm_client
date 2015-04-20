import QtQuick 1.1
import "MTColumn" as MTColumn

Rectangle {
    id:rect_window
    width: 100
    height: 62
    z:9
    visible: false

    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        anchors{top:parent.top}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("商品详细信息")
            font{bold: true;pixelSize: 20}
        }
    }

    //2 商品图片区
    Rectangle{
        id:rect_productImage
        width: parent.width * 0.35
        height: parent.height * 0.35
        anchors{top:rect_title.bottom;topMargin: 2}
        border{color: "blue";width: 1}
    }

    //3.商品编号
    Rectangle{
        id:rect_productInfo
        width: parent.width
        height: parent.height * 0.55
        anchors{top:rect_productImage.bottom ; topMargin: 2}
        border{color: "gray";width: 1}
        Column{
            anchors.fill: parent
            spacing: 10
            MTColumn.VMCoumnTextInput{
                text_title: qsTr("商品编号")
                text_contex: "11"
            }
            MTColumn.VMCoumnTextInput{
                text_title: qsTr("商品单价")
                text_contex: "11"
            }
        }
    }

    //4.工具栏
    Rectangle{
        id:rect_tool
        z:5
        width: parent.width
        height: parent.height * 0.05
        anchors.bottom:parent.bottom
        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.6
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            onClicked: {
                rect_window.visible = false
            }
        }
    }




    function productInfoFlush(p){
        console.log("刷新商品信息" + p);

    }




}

