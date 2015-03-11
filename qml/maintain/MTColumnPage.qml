import QtQuick 1.1

Rectangle {
    width: 100
    height: 62
    visible: false
    onVisibleChanged: {
        if(visible == true){
            if(product_model.count != columnManage.columnCount){
                product_model.clear();
                columnCreate();
            }
        }
    }

    // 2.货道管理展示区域
    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.95
        anchors{
            top:title.bottom
            topMargin: 5
        }
        //定义列表组件
        Component{
            id:product_delegate
            Rectangle{
                id:product_rect
                width: product_gridView.cellW
                height: product_gridView.cellH
                Rectangle{
                    width: parent.width * 0.8
                    height:parent.height * 0.8
                    anchors.centerIn: parent
                    border{
                        color: "gray"
                        width: 1
                    }
                    color: (column_state == 1) ? "blue": (column_state == 3 ? "yellow": "red")
                    opacity: 0.9
                    Text {
                        anchors.centerIn: parent
                        text: column_id
                        opacity: 0.4
                        font{
                            pixelSize: 12
                            bold: true
                        }
                    }
                }
            }
        }
        ListModel{
            id:product_model
        }
        //商品列表框
        GridView{
            id:product_gridView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            property real cellW: (parent.width) / 10.0
            property real cellH: (parent.height) / 12.0
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 0
        }
    }



    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        anchors{
            top:parent.top
            topMargin: 0
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
            text: qsTr("货道管理")
            font{
                bold: true
                pixelSize: 20
            }
        }
    }

    function vmCreateColumn(){
        product_model.append({
                          "column_id": 1,
                          "column_state":1,
                         });
        var column = product_model.get(product_model.count - 1);
        column.product_index = product_model.count - 1;
       // console.log("创建商品:" + product + product.product_index);
        return column;
    }

    function columnCreate(){
        console.log("货道列表模型 " + columnManage.columnCount);
        for(var i = 0;i < columnManage.columnCount;i++){
            var col = columnManage.getColumnObjByIndex(i);
            var column = vmCreateColumn();
            column.column_id = col.id % 1000;
            console.log("id=" + col.id + "state:" + col.state);
            column.column_state = col.state;
        }
    }

    function columnClear(){
        product_model.clear();
    }

}

