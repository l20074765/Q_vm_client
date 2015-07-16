import QtQuick 1.1
import "Column.js" as Column
import Qtvm 1.0


Rectangle {
    id:cabinet_rect
    width: 100
    height: 300
    z:5
    signal cellClicked()
    property Item topParent: null
    property int cabinetNo: 0
    property alias listModel_column: product_model

    Rectangle{
        id:title_rect
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{top:parent.top}
        Rectangle{
            width: parent.width * 0.2
            height: parent.height * 0.8
            anchors.centerIn: parent
            Text{
                anchors.fill: parent
                font{
                    bold:true;
                    pixelSize: (parent.width < parent.height) ? parent.width * 0.8: parent.height * 0.9;
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                color:"blue"
                text: cabinetNo
            }
        }


        //按键组
        Row{
            width:parent.width * 0.4
            height:parent.height * 0.6
            anchors{left: parent.left;leftMargin: 5;}
            anchors.verticalCenter: parent.verticalCenter
            spacing: 15

            MyButton{
                width:parent.width * 0.4
                height:parent.height
                font{bold:false;pixelSize: (width < height) ? width * 0.4: height * 0.6;}
                text: "新建货道"
                onClicked: {
                    vmCreateColumn(product_model.count + 1);
                }
            }

            MyButton{
                width: parent.width * 0.4
                height: parent.height
                font{bold:false;pixelSize: (width < height) ? width * 0.4: height * 0.6;}
                text: "一键补货"
            }

        }





    }


    Rectangle{
        id:cmCabinet_rect
        width: parent.width
        height: parent.height * 0.9
        z:3
        anchors{top:title_rect.bottom}
        //商品列表框
        GridView{
            id:product_gridView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            property real cellW: (parent.width) / 10.01
            property real cellH: (parent.height) / 10.01
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 1 //不能设置0 否则出错
        }

        ListModel{
            id:product_model
        }
        //定义列表组件
        Component{
            id:product_delegate
            Rectangle{
                width: product_gridView.cellW
                height:product_gridView.cellH
                VMColumn{
                    width: parent.width * 0.9
                    height:parent.height * 0.9
                    anchors.centerIn: parent
                    col_bin:column_bin
                    col_column:column_column
                    col_total: column_total
                    col_state:column_state
                    col_remain: column_remain
                    col_goods: column_goods
                    onColumnClicked: {
                        var itemColumn = Column.loadComponent(topParent);
                        itemColumn.flush(colId);
                    }
                }
            }


        }
    }

    Rectangle{
        id:tool_rect
        width: parent.width
        height: parent.height * 0.05
        anchors{top:cmCabinet_rect.bottom}
        z:5
        Row{
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.topMargin: 5
            spacing: 10
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "#677ae1"
                Text {
                    anchors.centerIn: parent
                    text: "正常"
                    font{bold: false;
                        pixelSize: (parent.width < parent.height) ? parent.width * 0.4: parent.height* 0.4}
                    color: "white"
                }
            }
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "#f3c110"
                Text {
                    anchors.centerIn: parent
                    font{bold: false;pixelSize: (parent.width < parent.height) ? parent.width * 0.4: parent.height* 0.4}
                    text: "无货"
                    color: "white"
                }
            }

            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "#f65e09"
                Text {
                    anchors.centerIn: parent
                    font{bold: false;pixelSize: (parent.width < parent.height) ? parent.width * 0.4: parent.height* 0.4}
                    text: "故障"
                    color: "white"
                }
            }
            Rectangle{
                width: tool_rect.width * 0.1;height: tool_rect.height * 0.5
                color: "gray"
                Text {
                    anchors.centerIn: parent
                    font{bold: false;pixelSize: (parent.width < parent.height) ? parent.width * 0.4: parent.height* 0.4}
                    text: "禁用"
                    color: "white"
                }
            }
        }


    }



    function listClear(){
        product_model.clear();
    }

    function vmCreateColumn(id){
        console.log("创建货道:" + id )
        product_model.append({
                    "column_state":VmcMainFlow.EV_COLUMN_NORMAL,
                    "column_remain":0,
                    "column_goods":"",
                    "column_bin":cabinet_rect.cabinetNo,
                    "column_total":0,
                    "column_column":id,
                    "col_index":1
                         });
        var column = product_model.get(product_model.count - 1);
        //console.log("创建货道: column=" + column);
        return column;
    }


    function vmCreateColumnByColumn(column){
        var col = vmCreateColumn(column.column);
        if(col){
            col.column_remain = column.remain;
            col.column_state = column.state;
            col.column_total = column.total;
            col.column_goods = column.productNo;
        }
        else{
            console.log("创建货道:vmCreateColumn失败");
        }
    }


}

