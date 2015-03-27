import QtQuick 1.1

Rectangle {
    id:mtTradeManagePage
    width: 100
    height: 62
    visible: false
    property Item curPage: mtTrade_mainPage
    property Item lastPage: mtTrade_mainPage


    property MTColumnPage columnPage: mtTrade_columnPage
    // 1. 交易管理主页
    Rectangle{
        id:mtTrade_mainPage
        width: parent.width
        height: parent.height
        anchors.fill: parent
        visible: true
        Component{
            id:mtTrade_delegate
            Rectangle{
                width: mtTrade_mainPage.width
                height: mtTrade_mainPage.height * 0.06
                border{
                    color: "gray"
                    width: 2
                }
                Text {
                    anchors.centerIn: parent
                    text: mt_title
                    font{
                        bold: true
                        pixelSize: 20
                    }
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        mtTrade_listView.currentIndex = mtTrade_curIndex;
                        console.log("点击" + mtTrade_listView.currentIndex);
                        mtTradeSelectPage(mtTrade_listView.currentIndex);
                    }
                }
            }
        }

        ListModel{
            id:mtTrade_model
            ListElement{
                mt_title:"商品管理"
                mtTrade_curIndex:0
            }
            ListElement{
                mt_title:"货道管理"
                mtTrade_curIndex:1
            }
            ListElement{
                mt_title:"交易数据"
                mtTrade_curIndex:2
            }
            ListElement{
                mt_title:"销售报表"
                mtTrade_curIndex:3
            }
        }
        ListView{
            id:mtTrade_listView
            width: parent.width
            height: parent.height
            anchors.fill: parent
            spacing: 5
            delegate: mtTrade_delegate
            model: mtTrade_model
            flickableDirection:Flickable.VerticalFlick


        }

    }

    // 2. 商品管理页面
    MTProductPage{
        id:mtTrade_productPage
        objectName: "trade_productPage_obj"
        anchors.fill: parent
        visible: false
        onGoodsList_clicked: {
            mtTradeSwitchPage(mtTrade_productDetailPage);
        }
    }

    //3.货道管理页面
    MTColumnPage{
        id:mtTrade_columnPage
        anchors.fill: parent
        visible: false
    }


    //4.商品详细页面
    MTProductDetailPage{
        id:mtTrade_productDetailPage
        anchors.fill: parent
        visible: false
    }


    function mtTradeSelectPage(s){
        if(s == 0){
           mtTradeSwitchPage(mtTrade_productPage);
        }
        else if(s == 1){
           mtTradeSwitchPage(mtTrade_columnPage);
        }
        else {
           mtTradeSwitchPage(mtTrade_mainPage);
        }
    }

    function mtTradeSwitchPage(page){
            lastPage = curPage;
            curPage = page;
            lastPage.visible = false;
            curPage.visible = true;
    }

    function mtTrade_productClear(){
        mtTrade_productPage.mtProductClear();
    }

    function mtTrade_productCreate(goodsListItem){

        mtTrade_productPage.mtProductCreat(goodsListItem);
    }


}

