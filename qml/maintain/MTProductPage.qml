import QtQuick 1.1
import "../custom" as Custom
import "../trade" as Trade
import "./MTColumn" as MTColumn
import "MainTain.js" as MainTainJs
import "../custom" as Custom

Rectangle {
    id:mt_productPage
    width: 100
    height: 62
    visible: false
    signal goodsList_clicked()
    property string picPath: ""
    property Item  productDetailItem:null
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
            Custom.Product{
                width: product_gridView.cellW * 0.9
                height:product_gridView.cellH * 0.9
                productID: product_id
                productName:product_name
                productPrice: product_price
                productIndex: product_index
                productImage: product_image
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
            property real cellW: (parent.width) / 4.1
            property real cellH: (parent.height) / 5.1
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 1

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    var m = product_gridView.indexAt(mouseX,mouseY);
                    console.log("选中商品:" + m +
                                " count=" + product_gridView.count);
                    if(m != -1){
                        product_gridView.currentIndex = m;
                        if(productDetailItem == null){
                            productDetailItem =  MainTainJs.loadComponent(mt_productPage,"MTProductDetailPage.qml");
                        }
                        if(productDetailItem){
                            productDetailItem.productInfoFlush(product_gridView.currentItem);
                            productDetailItem.visible = true;
                        }
                    }
                }
            }

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


    function productFlush(){
        mtProductClear();
        for(var i = 0;i < sqlProductList.size;i++){
            var product = sqlProductList.at(i);
            var p = vmCreateProduct();
            p.product_name = product.name;
            p.product_id = product.id;
            p.product_price =  product.salePriceStr;
            p.product_image = product.image;
        }
    }



    function vmCreateProduct(){
        product_model.append({
                          "product_id": "",
                          "product_name":"商品名称",
                          "product_price": "0.00",
                          "product_image":"",
                          "product_index": 0
                         });
        var product = product_model.get(product_model.count - 1);
        product.product_index = product_model.count - 1;
        return product;
    }



    function mtProductClear(){
        product_model.clear();
    }


}
