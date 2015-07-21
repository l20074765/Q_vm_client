import QtQuick 1.1

Rectangle {
    width: 100
    height: 62
    property alias listZ:cartListView.z
    z:2
    Rectangle{
        id:cartBar
        width: parent.width
        height:parent.height * 0.1
        anchors.top:parent.top
        z:2
        color: "#d6c6e7"
        Row{
            width: parent.width
            height: parent.height
            anchors.fill: parent
            spacing: 1
            Text {
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //font.bold: true
                font.pixelSize: (width < height) ? width * 0.8: height * 0.8
                text: "商品"
            }
            Text {
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //font.bold: true
                font.pixelSize: (width < height) ? width * 0.8: height * 0.8
                text: "名称"
            }
            Text {
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //font.bold: true
                font.pixelSize: (width < height) ? width * 0.8: height * 0.8
                text: "单价"
            }
            Text {
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //font.bold: true
                font.pixelSize: (width < height) ? width * 0.8: height * 0.8
                text: "数量"
            }
            Text {
                width: parent.width * 0.2
                height: parent.height
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                //font.bold: true
                font.pixelSize: (width < height) ? width * 0.8: height * 0.8
                text: "操作"
            }
        }
    }

    //商品列表栏
    Rectangle{
        width: parent.width
        height:parent.height * 0.75
        anchors.top:cartBar.bottom
        ListView{
            id:cartListView
            width: parent.width
            height:parent.height
            z:0
            delegate: cartDelegate
            model: cartListModel
            orientation: ListView.Vertical
            currentIndex: -1
        }

        ListModel{
            id:cartListModel
        }

        Component{
            id:cartDelegate
            Rectangle{
                width: cartListView.width
                height:cartListView.height * 0.3
                Row{
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent
                    spacing: 1
                    Rectangle{
                        width: parent.width * 0.2
                        height: parent.height
                        Image{
                            width: parent.width * 0.4
                            height: parent.height * 0.6
                            anchors.centerIn: parent
                            smooth: true
                            source: "../../images/product/default_product.png"
                        }
                    }

                    Text{
                        width: parent.width * 0.2
                        height: parent.height
                        smooth: true
                        text:product_name
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: (width < height) ? width * 0.4: height * 0.4
                    }
                    Text{
                        width: parent.width * 0.2
                        height: parent.height
                        smooth: true
                        text:product_price
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: (width < height) ? width * 0.4: height * 0.4
                    }

                }
            }
        }
    }


    Rectangle{
        width:parent.width
        height:parent.height * 0.2
        anchors.bottom:parent.bottom
        z:2
        Image{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            source: "../../images/tool/jiesuan1.png"
            fillMode: Image.PreserveAspectFit
            smooth: true

        }
    }

    function createList(){
        for(var i = 0;i < 20;i++){
            cartListModel.append({"product_name":"商品名称"  + i,
                                 "product_price":"1.00"});
        }

    }
}

