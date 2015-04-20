import QtQuick 1.1

Rectangle{
    id:rect_window
    width: 100
    height: 200
    //定义列表组件
    Component{
        id:product_delegate
        Product{
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
    }


    function append(){
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
}
