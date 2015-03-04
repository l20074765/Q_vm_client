import QtQuick 1.1
import "maintain" as MainTain
import "ads" as Ads
import "custom" as Custom
import "trade" as Trade


//主界面
Rectangle {
    id:main_rect
    anchors.fill: parent
    property Item curPage:vmFaultPage
    property Item lastPage:vmFaultPage
    signal qmlActionSignal(int type,string req)

    //1.广告页面
    Ads.VMAdsPage{
        id:vmAdsPage
        anchors.fill: parent
        onAds_clicked: {
            if(curPage == vmAdsPage)
                vmPageSwitch(vmGoodsListPage);
        }
    }
    //2.故障页面
    Trade.VMFaultPage{
        id:vmFaultPage
        anchors.fill: parent
    }
    //3.商品列表
    Trade.VMGoodsListPage{
        id:vmGoodsListPage
        anchors.fill: parent
        onGoodsList_clicked: {
            var p = vmGoodsListPage.vmGetCurProductItem()
            vmTransactionPage.setGoodsInfo(p)
            console.log("进入交易界面" + p);
            vmPageSwitch(vmTransactionPage);
        }
        onBack_clicked: {
            vmPageSwitch(vmAdsPage);
        }
    }
    //4.交易界面
    Trade.VMTransactionPage{
        id:vmTransactionPage
        anchors.fill: parent
        onButton_pay_clicked:{
            var p = vmGoodsListPage.vmGetCurProductItem();
            vmPayPage.vmPayAddProduct(p);
            vmPayPage.payqurePicSet(0);
            vmPageSwitch(vmPayPage);
            qmlActionSignal(1,p.product_id);
        }
        onBack_clicked: {
            vmPageSwitch(vmGoodsListPage);
        }
    }

    //5.支付界面
    Trade.VMPayPage{
        id:vmPayPage
        anchors.fill: parent
        onBack_clicked: {
            vmPayPage.listViewClear();
            vmPageSwitch(vmGoodsListPage);
        }

    }

    //6.成功支付后的出货界面
    Trade.VMTradeoutPage{
        id:vmTradeoutPage
        anchors.fill: parent
    }
    //7.出货失败界面
    Trade.VMTradeFailPage{
        id:vmTradeFailPage
        anchors.fill: parent
        onBack_clicked: {
           vmPageSwitch(vmAdsPage);
        }
    }

    //8.维护主界面
    MainTain.MTMain{
        id:vmMTMainPage
        anchors.fill: parent
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
        else if(s == 4) //维护
        {

            vmPageSwitch(vmMTMainPage);
        }
        else //故障
        {
           //vmPageSwitch(vmFaultPage)
            vmPageSwitch(vmFaultPage)

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
        //vmPayPage.pic_image = "../../images/alipay/ali_code.png"
        vmPayPage.payqurePicSet(1);
    }

    //支付结果
    function tradeResult(res){
        console.log("支付结果上报:" + res);
        if(res == 1){ //支付成功
            vmPageSwitch(vmTradeoutPage);
        }
        else{

        }
    }

    //页面切换函数
    function vmPageSwitch(page){
        main_rect.lastPage = main_rect.curPage
        main_rect.curPage = page
        main_rect.lastPage.visible = false
        main_rect.curPage.visible = true

    }



}




