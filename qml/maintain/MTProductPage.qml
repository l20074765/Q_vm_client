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
                pixelSize: (parent.height < parent.width) ?
                             parent.height * 0.5: parent.width * 0.1;
            }
        }

        MTColumn.MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                //bold: true
                pixelSize: (height < width) ?
                               height * 0.6 : width * 0.1;
            }

            text: "新增商品"
            onClicked: {
                mtproductEnterEdit();
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
                width: product_gridView.cellW
                height:product_gridView.cellH
                productID: product_id
                productName:product_name
                productPrice: product_price
                productIndex: product_index
                productImage: product_image
                onGoods_clicked: {
                    console.log("选中商品 ID=" + productID + " Index=" + product.productIndex + "; " + product);
                    productDetailItem =  MainTainJs.loadComponent(mt_productPage,"MTProductDetailPage.qml");
                    if(productDetailItem){
                       //var item = product_gridView.childAt(product.mouseX,product.mouseY);
                        productDetailItem.newProduct = false;
                        productDetailItem.productInfoFlush(product);
                        productDetailItem.visible = true;
                        productDetailItem.listModel = product_model;
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
            anchors.centerIn: parent
            property real cellW: (width) / 4.02
            property real cellH: (height) / 4.4
            cellWidth: cellW
            cellHeight: cellH

            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 1
        }
    }

    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{
            bottom: parent.bottom
        }
        smooth: true
        border{ color: "gray";width: 1 }
        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            font{
                bold: true
                pixelSize: (height < width) ?
                               height * 0.6 : width * 0.1;
            }
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
            p.product_image = product.pic;
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

    function mtproductEnterEdit(){
        var item =  MainTainJs.loadComponent(mt_productPage,"MTProductDetailPage.qml");
        if(item){
            item.productId  = "vm0001";
            item.productPrice = "1.00";
            item.productName = "";
            item.productPic = "";
            item.newProduct = true;
            item.visible = true;
            return item;
        }
        else{
          return null;
        }
    }

}
