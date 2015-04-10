import QtQuick 1.1
import "Column.js" as Column


Rectangle {
    id:rect
    width: 300
    height: 162
    property Item parentItem
    property string text_cabinet:"1"
    property string text_column:"11"
    property string text_remain:""
    property string text_r:""
    focus: true
    color: "white"
    opacity: 0.9
    MouseArea{ //覆盖一层鼠标区域 实现模态
        anchors.fill: parent
    }

    //标题栏
    Rectangle{
        id:title_rect
        width: parent.width
        height: parent.height * 0.05
        anchors.top:parent.top
        anchors.topMargin:0
        border{
            width: 2
            color:"gray"
        }

        Text{
            anchors.centerIn: parent
            font{
                bold:true
                pixelSize: parent.width * 0.05
            }
            text: "货道编辑"
        }
    }

    //正文区
    Rectangle{
        id:text_rect
        width: parent.width
        height:parent.height * 0.95
        anchors.top:title_rect.bottom
        anchors.topMargin:0

        //货道编辑区
        Rectangle{
            id:column_rect
            width: parent.width
            height: parent.height * 0.8

            Column{
                anchors.fill: parent
                spacing: 5
                VMCoumnTextInput{
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"货柜号:"
                    text_contex: text_cabinet
                }
                VMCoumnTextInput{
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"货道号:"
                    text_contex: text_column
                }
                VMCoumnTextInput{
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"商品号:"
                    text_contex: ""
                }
                VMCoumnTextInput{
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"剩余量:"
                    text_contex: text_remain
                }
                VMCoumnTextInput{
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"总容量:"
                    text_contex: text_remain
                }
            }







        }



        Rectangle{
            width: parent.width * 0.6
            height: parent.height * 0.05
            anchors{
                bottom: parent.bottom
                bottomMargin: 150
                horizontalCenter: parent.horizontalCenter
            }
            color: "transparent"

            MyButton{
                width: parent.width * 0.4
                height: parent.height
                anchors{
                    left: parent.left
                    verticalCenter: parent.verticalCenter
                }

                font{
                    bold: true
                    pixelSize: parent.width * 0.05
                }
                text: "保存"
                onClicked: {
                   console.log("关闭 父对象是" + rect.parent)
                   Column.destroyItem(rect);

                }
            }
            MyButton{
                width: parent.width * 0.4
                height: parent.height
                anchors{
                    right: parent.right
                    verticalCenter: parent.verticalCenter
                }
                font{
                    bold: true
                    pixelSize: parent.width * 0.05
                }
                text: "返回"
                onClicked: {
                   console.log("关闭 父对象是" + rect.parent)
                   Column.destroyItem(rect);

                }
            }




        }




    }






}

