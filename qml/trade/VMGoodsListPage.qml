import QtQuick 1.0
import "../custom" as Custom
import "../custom/CreateQml.js" as CreateQml


Custom.VMWidget {
    id:goodsList_page
    property Item vmTransactionPage: null   //交易界面
    property int duration: 200
    property bool isCarted: cart_rect.visible
    property bool isHide:visible
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
        onTimerout: {
         back_clicked();
        }
    }


    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * parent.rectHR
        z:5
        anchors{top:title_bar.bottom}
        //商品展示区
        Rectangle{
            id:productList_rect
            width: parent.width
            height: parent.height
            anchors.top:parent.top
            z:5
            //商品列表栏
            Rectangle{
                width: parent.width
                height: parent.height
                anchors.top:parent.top
                z:5
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
                                //goodsList_page.hide();
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
                    z:2
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

            //分类栏
            Rectangle{
                id:peoductKind_rect
                width: parent.width
                height: 0//parent.height * 0.04
                anchors.bottom: parent.bottom
                z:5
                color: "blue"
                MouseArea{
                    anchors.fill: parent
                }
                visible: false
            }
        }

        //购物车
        Rectangle{
            id:cart_rect
            width: parent.width
            height: 0
            anchors.bottom: parent.bottom
            z:5
            visible: false
            MouseArea{
                anchors.fill: parent
            }

            //购物条
            Rectangle{
                id:cart_title
                width: parent.width
                height: parent.height * 0.15
                anchors.top: parent.top
                z:5
                Image {
                    width: parent.width
                    height: parent.height
                    anchors.fill: parent
                    smooth: true
                    source: "../../images/tool/test1.png"
                    rotation: 0
                }
                Text{
                    width: parent.width * 0.2
                    height: parent.height * 0.8
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: 5
                    smooth: true
                    font.bold: true
                    font.pixelSize: (width < height) ? width * 0.6 : height * 0.6
                    verticalAlignment: Text.AlignVCenter
                    text:"我的购物车"
                    color: "white"
                }

                Image{
                    width: parent.height * 1.2
                    height: parent.height *1.2
                    anchors.right: parent.right
                    anchors.rightMargin: 5
                    anchors.verticalCenter: parent.verticalCenter
                    source: "../../images/tool/close1.png"
                    smooth: true
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            product_gridView.cellW = productList_rect.width / 4.1;
                            productAnimBig.start();
                           // productAnimBig1.start();
                            cartAnimHide.start();
                        }
                    }
                }
            }
            //购物车
            Rectangle{
                width: parent.width
                height: parent.height * 0.85
                anchors.top: cart_title.bottom
                z:2
                CartProductList{
                    id:cartList
                    anchors.fill: parent
                }
            }
        }
    }

    //状态栏区域
    Custom.VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height * parent.statusHR
        z:10
        anchors{top:main_rect.bottom}
        function1Test: "添加购物车"
        onStatus_back_clicked: {
            back_clicked()//执行返回按钮
        }
        onFunction1_clicked: {
            if(cart_rect.visible == false){
//                productList_rect.height = main_rect.height * 0.7;
//                cart_rect.height = main_rect.height * 0.3
                cart_rect.visible = true
                product_gridView.cellW = productList_rect.width / 5.1
                productAnimSmall.start();
                //productAnimSmall1.start();
                cartAnimShow.start();
                cartList.createList();
                console.log("列表：" + "listZ=" + cartList.listZ + " product_gridView=" + product_gridView.z);
            }
        }
    }



    //------------------------------
    // 动画
    //------------------------------
    PropertyAnimation {
        id: cartAnimShow
        target: cart_rect
        duration: goodsList_page.duration
        easing.type:  Easing.Linear
        property: 'height';
        from: 0;
        to: main_rect.height * 0.3
    }
    PropertyAnimation {
        id: cartAnimHide
        target: cart_rect
        duration: goodsList_page.duration
        easing.type: Easing.Linear
        property: 'height'
        from: main_rect.height * 0.3
        to: 0
        onCompleted: {
            cartClose()
        }
    }
    function cartClose(){
        cart_rect.visible = false;
    }

    //------------------------------
    // 动画
    //------------------------------
    PropertyAnimation {
        id: productAnimBig
        target: productList_rect
        duration: goodsList_page.duration
        easing.type:  Easing.Linear
        property: 'height';
        from: main_rect.height * 0.7
        to: main_rect.height
    }
    PropertyAnimation {
        id: productAnimSmall
        target: productList_rect
        duration: goodsList_page.duration
        easing.type: Easing.Linear
        property: 'height'
        from: main_rect.height
        to: main_rect.height * 0.7
    }


    PropertyAnimation {
        id: productAnimBig1
        target: product_gridView
        duration: goodsList_page.duration
        easing.type:  Easing.Linear
        property: 'cellW';
        from: productList_rect.width / 5.1
        to: productList_rect.width / 4.1
    }
    PropertyAnimation {
        id: productAnimSmall1
        target: product_gridView
        duration: goodsList_page.duration
        easing.type: Easing.Linear
        property: 'cellW'
        from: productList_rect.width / 4.1
        to: productList_rect.width / 5.1
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

    function pageShow(){ //页面切换
        show();
        title_bar.timer_flush(120);
        title_bar.timer_start();
    }

    function pageHide(){  //页面隐藏
        title_bar.timer_stop();
        hide();
    }

}

