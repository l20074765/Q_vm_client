import QtQuick 1.1

Rectangle {
    width: 100
    height: 62
    visible: false
    onVisibleChanged: {
        if(visible == true){
            columnCreate();
        }
        else{
            product_model.clear();
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
                    color: "red"
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



    function columnCreate(){
        for(var i = 0;i < 100;i++){
            product_model.append({"column_id": "1"});
            var product = product_model.get(product_model.count - 1);
            product.column_id = product_model.count - 1;
        }
    }

}

