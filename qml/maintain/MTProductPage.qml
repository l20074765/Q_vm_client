import QtQuick 1.1
import "../custom" as Custom
import "../trade" as Trade
import "./MTColumn" as MTColumn
Rectangle {
    id:mt_productPage
    width: 100
    height: 62
    visible: false
    signal goodsList_clicked()

    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{top:parent.top ;topMargin: 0}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("商品管理")
            font{
                bold: true
                pixelSize: 20
            }
        }
    }

    // 2.商品列表区
    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.9
        z:3
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
                Custom.Product{
                    width: parent.width * 0.9
                    height:parent.height * 0.9
                    anchors.centerIn: parent
                    productID: product_id
                    productName:product_name
                    productPrice: product_price
                    productIndex: product_index
                    onGoods_clicked: {
                          //商品点击
                        product_gridView.currentIndex = productIndex
                        console.log("商品选中" + "index:" + productIndex.toString()
                                    + " curIndex:" + product_gridView.currentIndex);
                        goodsList_clicked();
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
            property real cellW: (parent.width) / 4.0
            property real cellH: (parent.height) / 5.0
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 0
        }
    }

    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors.top:main_rect.bottom
        border{ color: "gray";width: 1 }
        Row{
            anchors.centerIn: parent
            spacing: 10
            MTColumn.MyButton{
                text: "新增商品"
                onClicked: {
                }
            }
        }

        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.6
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            onClicked: {
                mt_productPage.visible = false
            }
        }
    }


    function vmCreateProduct(){
        product_model.append({
                          "product_id": "",
                          "product_name":"商品名称",
                          "product_price": "0.00",
                          "product_index": 0
                         });
        var product = product_model.get(product_model.count - 1);
        product.product_index = product_model.count - 1;
        return product;
    }

    function mtProductCreat(goodsListItem){
        var prodeuct_listModel = goodsListItem.product_listModel;
        console.log("商品列表模型 " + prodeuct_listModel.count);
        for(var i = 0;i < prodeuct_listModel.count;i++){
            var productObj = prodeuct_listModel.get(i);
            var product = vmCreateProduct();
            product.product_id = productObj.product_id;
            product.product_name = productObj.product_name;
            product.product_price = productObj.product_price;
        }
    }

    function mtProductClear(){
        product_model.clear();
    }


}
