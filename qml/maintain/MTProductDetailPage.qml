import QtQuick 1.1
import "MainTain.js" as MainTainJs
import "./MTColumn" as MTColumn
import "../custom"  as Custom
import Qtvm 1.0

Rectangle {
    id:rect_productDetailPage
    width: 100
    height: 62
    z:9
    visible: false
    //property Item picListPage: null
    property Item picItem: null
    property Item loadingMask: null

    property ListModel listModel:null
    property Item curProduct:null
    property alias productId:proudct_id.text_contex
    property alias productPrice:proudct_price.text_contex
    property alias productName: proudct_name.text_contex
    property alias productPic:  product_image.source
    property bool  newProduct: false

    MouseArea{ //禁止事件穿透
        anchors.fill: parent
    }

    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        anchors{top:parent.top}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("编辑商品")
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
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            text: "删除商品"
            onClicked: {
                if(newProduct == false){
                    mainView.qmlActionSlot(MainFlow.QML_SQL_PRODUCT_DELETE,productId);
                    var item = listModel.remove(curProduct.productIndex);
                    var count = listModel.count;
                    console.log("ListModel:count=" + count);
                    for(var i = 0;i < count;i++){
                        var t = listModel.get(i);
                        listModel.setProperty(i,"product_index",i);
                        //console.log("调整:id=" + t.product_id + " i=" + i);
                    }
                    console.log("删除商品:index=" + curProduct.productIndex);
                    hide();
                }
            }
        }

    }

    //2 商品图片区
    Rectangle{
        id:rect_productImage
        width: parent.width * 0.45
        height: parent.height * 0.35
        anchors{top:rect_title.bottom;topMargin: 5;
                left: parent.left;leftMargin: 5}
       // border{color: "blue";width: 1}
        smooth: true
        Image{
            id:product_image
            anchors.fill: parent
            source: productPic
            smooth: true
            fillMode: Image.PreserveAspectFit
        }
    }

    MTColumn.MyButton{
        width: parent.width * 0.15
        height: parent.width * 0.15
        anchors{
            right: parent.right
            rightMargin: parent.width * 0.025
            bottom: rect_productInfo.top
            bottomMargin: parent.width * 0.025
        }
        text: "更改图片"
        font{
            bold: true
            pixelSize: width * 0.16
        }
        onClicked: {
            var picListPage =  MainTainJs.loadComponent(rect_productDetailPage,"MTProductPicList.qml");
            if(picListPage){
                picListPage.show();
            }

        }
    }




    //3.商品编号
    Rectangle{
        id:rect_productInfo

        width: parent.width
        height: parent.height * 0.55
        anchors{top:rect_productImage.bottom ; topMargin: 2}
        border{color: "gray";width: 1}
        Column{
            anchors.fill: parent
            spacing: 10
            MTColumn.VMCoumnTextInput{
                id:proudct_id
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("商品编号:")
                text_contex: "vm0001"
                readOnly:rect_productDetailPage.newProduct == true ?  false:true
                onDisplayTextChanged: {
                    if(rect_productDetailPage.newProduct == true){
                        if(text_contex =="" || sqlProductList.isContains(text_contex) == true){
                            tipText = "*重复"
                        }
                        else{
                             tipText = ""
                        }
                        console.log("商品编号验证");
                    }
                }
            }
            MTColumn.VMCoumnTextInput{
                id:proudct_name
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("商品名称:")
                text_contex: "商品名称"
            }
            MTColumn.VMCoumnTextInput{
                id:proudct_price
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("商品单价:")
                text_contex: "1.00"
                validator:DoubleValidator{id: intval; decimals: 2; bottom: 0; top: 100000000; notation:DoubleValidator.StandardNotation}
                onActiveFocusChanged: {
                    if(activeFocus == false){
                        text_contex = vm.priceCheck(text_contex);
                        console.log("单价矫正");
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
        anchors{
            bottom: parent.bottom
        }
        smooth: true
        border{ color: "gray";width: 1 }

        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.centerIn: parent
            text: "保存"
            font{
                bold: true
                pixelSize: (height < width) ?
                               height * 0.6 : width * 0.1;
            }
            onClicked: {
                if(rect_productDetailPage.newProduct == true){
                    if(productId == ""){
                       proudct_id.tipText = "*空";
                    }
                    else{
                        var p = sqlProductList.add(productId);
                        if(p == null){
                            console.log("新增商品失败 重复商品编号");
                            proudct_id.tipText = "*重复";
                        }
                        else{
                            loadingMask =  MainTainJs.loadComponent(rect_productDetailPage,"../custom/LoadingMask.qml");
                            loadingMask.visible = true;

                            p.name = productName;
                            p.id = productId;
                            p.salePriceStr =  productPrice;
                            p.pic = productPic;
                            sqlProductList.updateProductImage(p); //更新图片
                            mainView.qmlActionSlot(MainFlow.QML_SQL_PRODUCT_CREATE,productId);
                            //vm_main.qmlMainSignal.connect(rect_productDetailPage.loadingFinished);

                        }
                    }
                }
                else{ //修改商品
                    var p = sqlProductList.get(productId)
                    if(p == null){
                        console.log("修改商品失败 商品编号不存在");
                    }
                    else{
                        loadingMask =  MainTainJs.loadComponent(rect_productDetailPage,"../custom/LoadingMask.qml");
                        loadingMask.visible = true;
                        p.name = productName;
                        p.id = productId;
                        p.salePriceStr =  productPrice;
                        p.pic = productPic;
                        sqlProductList.updateProductImage(p); //更新图片
                        mainView.qmlActionSlot(MainFlow.QML_SQL_PRODUCT_UPDATE,productId);
                    }
                }
            }
        }


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
                hide();
            }
        }
    }





    function productInfoFlush(p){
        console.log("刷新商品信息" + p);
        if(p == null){
            productId  = "";
            productPrice = "1.00";
            productName = "";
            productPic = "";
            curProduct = null;

        }
        else{
            productId  = p.productID;
            productPrice = p.productPrice;
            productName = p.productName;
            productPic = p.productImage;
            curProduct = p;
        }
        proudct_id.tipText = "";
    }


    function loadingFinished(type,obj){
        console.log("测试qml信号" + "type=" + type+ " obj=" + obj);
        console.log("本对象:" + rect_productDetailPage);
        if(type == MainFlow.QML_SQL_PRODUCT_CREATE){
            rect_productDetailPage.loadingMask.destroy();
            if(obj == 1){//添加成功
                var topParent = rect_productDetailPage.parent;
                var product = topParent.vmCreateProduct();
                var p = sqlProductList.get(productId);
                product.product_name = p.name;
                product.product_id = p.id;
                product.product_price =  p.salePriceStr;
                product.product_image = vmConfig.qmlPath() +  p.pic;

            } 
        }
        else if(type == MainFlow.QML_SQL_PRODUCT_UPDATE){
            rect_productDetailPage.loadingMask.destroy();
            if(obj == 1 && listModel != null){
                var p1 = sqlProductList.get(productId);
                var index = curProduct.productIndex;
                console.log("productUpdate:index=" + index + " ID=" + p1.id);
                listModel.set(index,{"product_id":p1.id,
                                    "product_name":p1.name,
                                    "product_price":p1.salePriceStr,
                                    "product_image":vmConfig.qmlPath() +  p1.pic,
                                    "product_index":index});

            }
        }
        hide();
    }

    function hide(){
        rect_productDetailPage.visible = false;
        //rect_productDetailPage.destroy();
        //console.log("隐藏对象:" + rect_productDetailPage);
    }


    function connectSignal(){
        vm_main.qmlMainSignal.connect(rect_productDetailPage.loadingFinished);
    }

}

