import QtQuick 1.1
import "Column.js" as Column

Rectangle {
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
        anchors{
            top:title_rect.bottom
        }
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
            currentIndex: 0

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var m = parent.indexAt(mouse.x,mouse.y);
                    if(m != -1){
                       console.log("当前index改变" + m)
                       parent.currentIndex = m;
                       cellClicked();
                    }
                }
            }
        }
    }

    Rectangle{
        id:tool_rect
        width: parent.width
        height: parent.height * 0.1
        anchors{
            top:cmCabinet_rect.bottom
        }
        z:3
    }

    ListModel{
        id:product_model
    }
    //定义列表组件
    Component{
        id:product_delegate
        Rectangle{
            id:product_rect
            width: product_gridView.cellW
            height: product_gridView.cellH
            color: "transparent"
            VMColumn{
                width: parent.width * 0.95
                height:parent.height * 0.95
                anchors.centerIn: parent
                col_id:column_id
                col_state:column_state
                col_remain: column_remain
                col_goods: column_goods

            }


        }



    }

    function vmCreateColumn(id){
        console.log("创建货道:" + id + " model=" + product_model)
        product_model.append({
                          "column_id": id,
                          "column_state":1,
                          "column_remain":1,
                          "column_goods":"jp00002",
                          "col_index":0

                         });
        var column = product_model.get(product_model.count - 1);
        column.col_index = product_model.count - 1;
        return column;
    }


}

