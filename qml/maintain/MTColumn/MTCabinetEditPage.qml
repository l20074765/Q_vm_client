import QtQuick 1.1
import "../../custom"  as Custom


Rectangle {
    id:rect_cabinetEditPage
    width: 100
    height: 62

    MouseArea{ //禁止事件穿透
        anchors.fill: parent
    }
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
            text: qsTr("编辑货柜")
            font{
                bold: true
                pixelSize: (parent.height < parent.width) ?parent.height * 0.5: parent.width * 0.1;
            }
        }
        MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                pixelSize: (height < width) ?height * 0.6 : width * 0.1;
            }

            text: "删除商品"
            onClicked: {
                 hide();
            }
        }

    }


    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{
            bottom: parent.bottom
        }
        smooth: true
        border{ color: "gray";width: 1 }

        MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.centerIn: parent
            text: "保存"
            font{
                bold: true
                pixelSize: (height < width) ?
                               height * 0.6 : width * 0.1;
            }
            onClicked: {
                hide();
            }
        }

        MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            font{
                bold: true
                pixelSize: (height < width) ?height * 0.6 : width * 0.1;
            }
            onClicked: {
                hide();
            }
        }
    }




    function hide(){
        rect_cabinetEditPage.visible = false;
    }


}

