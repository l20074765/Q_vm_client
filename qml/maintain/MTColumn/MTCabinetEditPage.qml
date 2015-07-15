import QtQuick 1.1
import "../../custom"  as Custom


Rectangle {
    id:rect_cabinetEditPage
    width: 100
    height: 62
    property int no: 0
    property int sum:80
    property int type:1
    property alias cabinetNo: cabinet_id.text_contex
    property alias colSum: cabinet_sum.text_contex
    property string info:""

    MouseArea{ //禁止事件穿透
        anchors.fill: parent
    }
    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        z:2
        anchors{top:parent.top}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("编辑货柜")
            font{
                bold: true
                pixelSize: (parent.height < parent.width) ? parent.height * 0.5: parent.width * 0.1;
            }
        }
        MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                left: parent.left
                leftMargin: 5
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

    //2 商品图片区
    Rectangle{
        width: parent.width
        height: parent.height * 0.9
        z:2
        anchors{top:rect_title.bottom;topMargin: 1;}

        Column{
            width: parent.width
            height: parent.height * 0.6
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 10
            VMCoumnTextInput{
                id:cabinet_id
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("货柜编号:")
                text_contex: "1"
                validator:DoubleValidator{ decimals: 0; bottom: 0; top: 1000; notation:DoubleValidator.StandardNotation}
            }
            VMCoumnTextInput{
                id:cabinet_sum
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("货道总数:")
                text_contex: "80"
                validator:DoubleValidator{ decimals: 0; bottom: 0; top: 1000; notation:DoubleValidator.StandardNotation}
            }
//            VMCoumnTextInput{
//                id:cabinet_price
//                width: parent.width
//                height: parent.height / 12
//                text_title: qsTr("货道类型:")
//                text_contex: "1"
//                validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
//            }
        }


    }




    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:2
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

                var cabinet = rect_cabinetEditPage.parent.createCabinet(cabinetNo);
                for(var i = 1;i <= colSum;i++){
                    cabinet.vmCreateColumn(i);
                }

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


    function flush(){
        console.log("flush");
    }

    function hide(){
        rect_cabinetEditPage.visible = false;
    }


}

