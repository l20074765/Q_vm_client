import QtQuick 1.0

VMWidget {
    id:goodsList_page
    signal goodsList_clicked()
    //商品组件数组
    property alias products:product_model.count
    anchors.fill: parent
    //定义列表组件
    Component{
        id:product_delegate
        Rectangle{
            id:product_rect
            width: product_gridView.cellW
            height: product_gridView.cellH
            Product{
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



    function vmGoodlist(){
        for(var i = 0;i < 10;i++)
        {
            var product = Qt.createQmlObject("Product{onGoods_clicked:{goodsCheckedId = goodsList_clicked();}}",grid_product,'err');
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
        console.log("创建商品:" + product);
        return product;
    }

    function vmDeleteProduct(p){
        p.destroy()
    }


    function vmGetCurProductItem(){
        var p = product_gridView.currentIndex;
        return product_model.get(p)
        //return product_gridView.currentItem;
    }

}

