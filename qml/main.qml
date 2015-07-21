import QtQuick 1.1
import "maintain" as MainTain
import "ads" as Ads
import "custom" as Custom
import "custom/CreateQml.js" as CreateQml
import "trade" as Trade
import Qtvm 1.0

//主界面
Rectangle {
    id:vm_main
    anchors.fill: parent
    property Item curPage:vmFaultPage
    property Item lastPage:vmFaultPage
    property Item vmAdsPage: null
    property Item vmMTMainPage: null
    signal qmlActionSignal(variant type,variant obj)
    signal qmlMainSignal(variant type,variant obj)
    //初始主页面
    Trade.VMFaultPage{
        id:vmFaultPage
        anchors.fill: parent
        visible: true;
    }
    //6.成功支付后的出货界面
    Trade.VMTradeoutPage{
        id:vmTradeoutPage
        anchors.fill: parent
        onBack_clicked: {
           vmPageSwitch(vmAdsPage);
           vmTradeClear();
        }
    }
    //7.出货失败界面
    Trade.VMTradeFailPage{
        id:vmTradeFailPage
        anchors.fill: parent
        onBack_clicked: {
           vmPageSwitch(vmAdsPage);
           vmTradeClear();

        }
    }




    //返回函数
    function back_req(){
        if(vm_main.curPage != vmFaultPage)
            vmPageSwitch(vmAdsPage)
    }



    //交互接口
    function vmcStatehandle(s){
        console.log(qsTr("主页面切换 state=") + s )
        var mainTainpage = vmGetMTMainPage();
        var adsPage = vmGetAdsPage();
        if(s == 2){         //正常
            vmPageSwitch(adsPage);
        }
        else if(s == 4) {   //维护
            mainTainpage.version = "V" + mainView.appVersion();
            vmPageSwitch(mainTainpage);
        }
        else{   //故障
            if(vm_main.curPage == vmAdsPage){
               vmPageSwitch(vmFaultPage);
            }
        }
        return 1;
    }


    //上报二维码图片
    function alipay_pic_ok(s){
        console.log("支付宝二维码图片开始获取");
        vmPayPage.payqurePicSet(1,s);
    }

    //支付结果
    function tradeResult(res){
        console.log("支付结果上报:" + res);
        if(res == MainFlow.QML_TRADE_OK){ //支付成功
            vmTradeoutPage.resultStr = "出货成功"
            vmPageSwitch(vmTradeoutPage);
        }
        else{
            vmPageSwitch(vmTradeFailPage);
        }
    }

    function payResult(res){
        console.log("支付结果上报:" + res);
        if(res == MainFlow.QML_PAYOUT_SUC){ //支付成功
            vmTradeoutPage.resultStr = "正在出货"
            vmPageSwitch(vmTradeoutPage);
        }
        else{
            vmPageSwitch(vmTradeFailPage);
        }
    }

    //页面切换函数
    function vmPageSwitch(page){
        vm_main.lastPage = vm_main.curPage
        vm_main.curPage = page
        vm_main.lastPage.pageHide();
        vm_main.curPage.pageShow();
    }

    function vmTradeClear(){
        vmPayPage.listViewClear();
        //vm.qmlActionSlot(MainObject.QML_TYPE_TRADE_CLEAR,"");
    }

    //qml负责与C++通信的槽函数入口
    function qmlActionSlot(type,obj){
        console.log(qsTr("处理QML请求:") + "type = " + type + " obj = " + obj);
        if(type == MainFlow.QML_VMC_STATE){
            vmcStatehandle(obj);
        }
        else if(type == MainFlow.QML_SQL_PRODUCT_FLUSH){
           // vmcproductAdd(obj);
        }
        else if(type == MainFlow.QML_SQL_COLUMN_ADD){
            vmMTMainPage.sqlActionSlot(type,obj);
        }
        else if(type == MainFlow.QML_ALI_PIC_OK){
            alipay_pic_ok(obj);
        }
        else if(type == MainFlow.QML_PAYOUT_TYPE){
            payResult(obj);
        }
        else if(type == MainFlow.QML_TRADE_TYPE){
            tradeResult(obj);
        }
        else if(type == MainFlow.QML_SQL_PRODUCT_CREATE){
            qmlMainSignal(type,obj);
        }
        else if(type == MainFlow.QML_SQL_PRODUCT_UPDATE){
            qmlMainSignal(type,obj);
        }
        else if(type == MainFlow.QML_SQL_CABINET_CREATE){
            qmlMainSignal(type,obj);
        }
        else if(type == MainFlow.QML_SQL_CABINET_DELETE){
            qmlMainSignal(type,obj);
        }
        else if(type == MainFlow.QML_SQL_COLUMN_UPDATE){
            qmlMainSignal(type,obj);
        }
    }

    //新增商品
    function vmcproductAdd(obj){
        var productList = obj;
        for(var i = 0;i < productList.size;i++){
            var product = productList.at(i);
           // console.log("提取商品"  + product);
            if(product == null){
                console.log("获取商品不存在");
                continue;
            }
            var p = vmGoodsListPage.vmCreateProduct();
            p.product_name = product.name;
            p.product_id = product.id;
            p.product_price =  product.salePriceStr;
            p.product_image = product.image;//

        }
    }


    function vmGetAdsPage(){
        if(vmAdsPage == null){
            vmAdsPage = CreateQml.loadComponent(vm_main,"ads/VMAdsPage.qml");
            //vmAdsPage.ads_clicked.connect(vmGoodsListPageSwitch);
            return vmAdsPage;
        }
        else{
            return vmAdsPage;
        }
    }




    function vmGetMTMainPage(){
        if(vmMTMainPage == null){
            vmMTMainPage = CreateQml.loadComponent(vm_main,"maintain/MTMain.qml");
            //vmMTMainPage.ads_clicked.connect(vmGoodsListPageSwitch);
            return vmMTMainPage;
        }
        else{
            return vmMTMainPage;
        }
    }
}




