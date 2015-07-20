import QtQuick 1.0
import "../custom" as Custom
import "../custom/CreateQml.js" as CreateQml


Custom.VMWidget {
    id:goodsList_page
    property Item vmTransactionPage: null   //交易界面
    signal back_clicked()
    //商品组件数组
    property alias products:product_model.count
    property alias product_listModel:product_model
    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * parent.titleHR
        z:5
        anchors{top:parent.top}
    }


    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * parent.rectHR
        z:2
        anchors{top:title_bar.bottom}
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
                    productImage: product_image
                    onGoods_clicked: {
                        console.log("商品选中" + "product:" + product);
                        var page = vmGetTransactionPage();
                        page.flush(product);
                        vm_main.timer_flush(120);
                        vm_main.timer_start();
                        page.show();
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
            property real cellW: (parent.width) / 4.1
            property real cellH: (parent.height) / 4.4
            cellWidth: cellW
            cellHeight: cellH
            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 0

        }


    }

    //状态栏区域
    Custom.VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height * parent.statusHR
        z:5
        anchors{top:main_rect.bottom}
        onStatus_back_clicked: {
            back_clicked()//执行返回按钮
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

    function vmDeleteProduct(p){
        p.destroy()
    }

    function productFlush(){
       productClear();
       console.log("VM:productFlush:size=" + sqlProductList.size);
        for(var i = 0;i < sqlProductList.size;i++){
            var product = sqlProductList.at(i);
            var p = vmCreateProduct();
            p.product_name = product.name;
            p.product_id = product.id;
            p.product_price =  product.salePriceStr;
            p.product_image = vmConfig.qmlPath() +  product.pic;
        }
    }

    function productClear(){
        product_model.clear();
    }


    function vmGetCurProductItem(){
        var p = product_gridView.currentIndex;
        return product_model.get(p)
    }

    function vmGetProductListModel(){
        return product_model;


    }

    function timer_out(){
        if(goodsList_page.visible == true){
            back_clicked();
        }
    }


    function vmGetTransactionPage(){
        if(vmTransactionPage == null){
            vmTransactionPage = CreateQml.loadComponent(goodsList_page,"VMTransactionPage.qml");
            vm_main.timerout.connect(vmTransactionPage.timer_out);
            return vmTransactionPage;
        }
        else{
            return vmTransactionPage;
        }
    }

}

