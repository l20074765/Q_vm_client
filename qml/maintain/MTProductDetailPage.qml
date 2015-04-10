import QtQuick 1.1
import "MTColumn" as MTColumn

Rectangle {
    width: 100
    height: 62
    visible: false

    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        anchors{
            top:parent.top
        }
        border{
            color: "gray"
            width: 1
        }
        Text {
            width: parent.width * 0.4
            height: parent.height
            anchors{
                left: parent.left
                leftMargin: 5
            }

            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter

            text: qsTr("商品详细信息")
            font{
                bold: true
                pixelSize: 20
            }
        }
    }

    //2 商品图片区
    Rectangle{
        id:productImage_rect
        width: parent.width
        height: parent.height * 0.35
        anchors{
            top:title.bottom
            topMargin: 2
        }
    }

    //3.商品编号
    Rectangle{
        id:productId_rect
        width: parent.width
        height: parent.height * 0.05
        anchors{
            top:productImage_rect.bottom
            topMargin: 2
        }
        border{
            color: "gray"
            width: 1
        }
        Row{
            anchors.fill: parent
            spacing: 10
            MTColumn.VMCoumnTextInput{

                text_title: qsTr("商品编号")
                text_contex: "11"
            }
            MTColumn.VMCoumnTextInput{

                text_title: qsTr("商品编号")
                text_contex: "11"
            }
            MTColumn.VMCoumnTextInput{

                text_title: qsTr("商品编号")
                text_contex: "11"
            }
        }


    }




}

