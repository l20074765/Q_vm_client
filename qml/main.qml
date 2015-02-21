import QtQuick 1.1
import QtDesktop 0.1

Rectangle {
    id:main_rect
    anchors.fill: parent
    property VMWidget curPage:vmFaultPage
    property VMWidget lastPage:vmFaultPage

    signal qmlActionSignal(int type)
    //1.广告页面
    VMAdsPage{
        id:vmAdsPage
        anchors.fill: parent
        onAds_clicked: {
          if(curPage == vmAdsPage)
            vmPageSwitch(vmGoodsListPage);
        }
    }

    //主界面显示区
    Rectangle{
        id:main_page
        width: parent.width
        height: parent.height*0.9
        anchors{top:title_bar.bottom}
        signal main_change_signal

        //2.故障页面
        VMFaultPage{
            id:vmFaultPage
            anchors.fill: parent
        }

        //3.商品列表陀
        VMGoodsListPage{
            id:vmGoodsListPage
            anchors.fill: parent

            onGoodsList_clicked: {
                var p = vmGoodsListPage.vmGetCurProductItem()
                vmTransactionPage.setGoodsInfo(p)
                console.log("进入交易界面" + p);
                vmPageSwitch(vmTransactionPage);
            }
        }


        //4.交易界面
        VMTransactionPage{
            id:vmTransactionPage
            anchors.fill: parent
            onButton_pay_clicked:{
                var p = vmGoodsListPage.vmGetCurProductItem()
                vmPayPage.vmPayAddProduct(p)
                vmPageSwitch(vmPayPage);
                qmlActionSignal(1);
            }
        }

        //5.支付界面
        VMPayPage{
            id:vmPayPage
            anchors.fill: parent
        }

        //6.成功支付后的出货界面
        VMTradeoutPage{
            id:vmTradeoutPage
            anchors.fill: parent
        }

    }

    //标题栏区域
    VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height*0.05
        anchors{top:parent.top}
    }

    //状态栏区域
    VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height*0.05
        anchors{top:main_page.bottom}
        onStatus_back_clicked: {
            //执行返回按钮
            back_req()
        }
    }


    //返回函数
    function back_req(){
        if(main_rect.curPage != vmFaultPage)
            vmPageSwitch(vmAdsPage)
    }



    //交互接口
    function vmcStatehandle(s){
        console.log(qsTr("主控板状态切换 state= ") + s )
        if(s == 2)//正常
        {
            vmPageSwitch(vmAdsPage)
        }
        else //故障
        {
           // vmPageSwitch(vmFaultPage)
            vmPageSwitch(vmGoodsListPage)

        }
        return 1;
    }

    function vmcproductChanged(){
        console.log("vmcproductChanged\n")        
        var product = goodsListPage.vmCreateProduct();
        product.productName = "测试商品"
        product.productPrice = "单价:1.00元"

    }



    function vmcproductAdd(){
        var p = vm.getAddProductObj()
        console.log("QML:vmcproductAdd\n" + p)

        if(p == null)//商品不存在
        {
            console.log("获取商品不存在");
            return
        }
        var product = vmGoodsListPage.vmCreateProduct();
        product.product_name = p.name
        product.product_id = p.id;
        product.product_price = p.salePrice
        //显示完成后需要告知后台销毁该对象
        vm.addProductFinish(product.product_index)

    }


    //上报二维码图片
    function alipay_pic_ok(){
        console.log("支付宝二维码图片开始获取");
        vmPayPage.pic_image = "../images/alipay/ali_code.png"

    }

    //支付结果
    function tradeResult(res){
        console.log("支付结果上报:" + res);
        if(res == 1){ //支付成功

        }
        else{

        }
    }

    //页面切换函数
    function vmPageSwitch(page){
        main_rect.lastPage = main_rect.curPage
        main_rect.curPage = page
        main_rect.lastPage.state="hide"
        main_rect.curPage.state="show"
        if(main_rect.curPage == vmAdsPage){//广告界面隐藏工具栏
            title_bar.visible=false
            status_bar.visible=false
            main_page.visible=false
        }
        else{
            title_bar.visible=true
            status_bar.visible=true
            main_page.visible=true

        }


    }



}




