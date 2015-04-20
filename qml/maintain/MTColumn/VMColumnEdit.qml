import QtQuick 1.1
import "Column.js" as Column
import Qtvm 1.0

Rectangle {
    id:rect
    width: 300
    height: 162
    property Item parentItem
    property VMColumn column:column_dummy
    property alias in_bin: input_bin.text_contex
    property alias in_column: input_column.text_contex
    property alias in_remain: input_remain.text_contex
    property alias in_total: input_total.text_contex
    property alias in_goods: input_goods.text_contex
    property bool isCreate:false
    focus: true
    color: "white"
    opacity: 0.9
    MouseArea{ //覆盖一层鼠标区域 实现模态
        anchors.fill: parent
    }

    VMColumn{
        id:column_dummy
        visible: false
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
                    id:input_bin
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"货柜号:"
                    text_contex: column.col_bin.toString()
                    readOnly:true
                }
                VMCoumnTextInput{
                    id:input_column
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"货道号:"
                    text_contex: column.col_column.toString()
                }
                VMCoumnTextInput{
                    id:input_remain
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"剩余量:"
                    text_contex: column.col_remain.toString()
                }
                VMCoumnTextInput{
                    id:input_total
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"总容量:"
                    text_contex: column.col_total.toString()
                }
                VMCoumnTextInput{
                    id:input_goods
                    width: parent.width
                    height: parent.height * 0.08
                    text_title:"商品号:"
                    text_contex: column.col_goods
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
                    column.col_bin = in_bin;
                    column.col_column = in_column;
                    column.col_goods = in_goods;
                    column.col_remain = in_remain;
                    column.col_total = in_total;
                    column.col_id = column.col_bin + "-" + column.col_column;
                    //VmcMainFlow
                    if(column.col_remain == 0){
                       if(column.col_state == VmcMainFlow.EV_COLUMN_NORMAL){
                           column.col_state = VmcMainFlow.EV_COLUMN_EMPTY;
                       }
                    }
                    else{
                        if(column.col_state == VmcMainFlow.EV_COLUMN_EMPTY){
                            column.col_state = VmcMainFlow.EV_COLUMN_NORMAL;
                        }
                    }
                    vm.qmlActionSlot(MainFlow.QML_SQL_COLUMN_CHANGE,column);
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
                   Column.destroyItem(rect);
                }
            }




        }




    }






}

