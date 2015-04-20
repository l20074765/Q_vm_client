import QtQuick 1.1
import "Column.js" as Column

Rectangle {
    id:cabinet_rect
    width: 768 * 1
    height: 768 * 1
    signal cellClicked()
    property alias listModel_column: product_model
    Rectangle{
        id:title_rect
        width: parent.width
        height: parent.height * 0.1
        z:3
        anchors{
            top:parent.top
        }
        Row{
           anchors.centerIn: parent
           spacing: 5
           MyButton{
               text: "一键补货"
           }

           MyButton{
               text: "新建货道"
               onClicked: {
                   vmCreateColumn(99);
               }
           }
        }
    }


    Rectangle{
        id:cmCabinet_rect
        width: parent.width
        height: parent.height * 0.8
        z:1
        anchors{top:title_rect.bottom}
        //商品列表框
        GridView{
            id:product_gridView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            property real cellW: (parent.width) / 10.1
            property real cellH: (parent.height) / 10.1
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 1 //不能设置0 否则出错

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var m = product_gridView.indexAt(mouse.x,mouse.y);
                    if(m != -1){
                       product_gridView.currentIndex = m;
                       cellClicked();
                       var itemColumn = Column.loadComponent(cabinet_rect);
                       var curItem =  product_gridView.currentItem;
                       itemColumn.column = curItem;
                    }
                }
            }
        }
    }

    Rectangle{
        id:tool_rect
        width: parent.width
        height: parent.height * 0.1
        anchors{top:cmCabinet_rect.bottom}
        z:3
        Row{
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 5
            spacing: 10
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "blue"
                Text {
                    anchors.centerIn: parent
                    text: "正常"
                    font{bold: true;pixelSize: parent.height * 0.4}
                    color: "white"
                }
            }
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "yellow"
                Text {
                    anchors.centerIn: parent
                    font{bold: true;pixelSize: parent.height * 0.4}
                    text: "无货"
                    color: "white"
                }
            }

            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "red"
                Text {
                    anchors.centerIn: parent
                    font{bold: true;pixelSize: parent.height * 0.4}
                    text: "故障"
                    color: "white"
                }
            }
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "gray"
                Text {
                    anchors.centerIn: parent
                    font{bold: true;pixelSize: parent.height * 0.4}
                    text: "禁用"
                    color: "white"
                }
            }
        }


    }

    ListModel{
        id:product_model
    }
    //定义列表组件
    Component{
        id:product_delegate
        VMColumn{
            width: product_gridView.cellW * 0.95
            height:product_gridView.cellH * 0.95
            col_id:column_id
            col_bin:column_bin
            col_column:column_column
            col_total: column_total
            col_state:column_state
            col_remain: column_remain
            col_goods: column_goods
        }
    }

    function vmCreateColumn(id){
        console.log("创建货道:" + id + " model=" + product_model)
        product_model.append({
                                "column_id": id,
                                "column_state":1,
                                "column_remain":1,
                                "column_goods":"jp00002",
                                "column_bin":1,
                                "column_total":1,
                                "column_column":11,
                                "col_index":0
                         });
        var column = product_model.get(product_model.count - 1);
        column.col_index = product_model.count - 1;
        return column;
    }


}

