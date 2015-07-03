import QtQuick 1.1
import "MainTain.js" as MainTainJs
import "./MTColumn" as MTColumn
import Qtvm 1.0

Rectangle {
    id:rect_window
    width: 100
    height: 62
    z:9
    visible: false
    property Item picListPage: null
    property Item picItem: null
    property string productPic: ""


    property alias productId:proudct_id.text_contex
    property alias productPrice:proudct_price.text_contex
    property alias productName: proudct_name.text_contex

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
            if(picListPage == null){
                picListPage =  MainTainJs.loadComponent(rect_window,"MTProductPicList.qml");
            }
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
                var p = sqlProductList.add(productId);
                if(p == null){
                    console.log("新增商品失败 重复商品编号");
                }
                else{
                    p.name = productName;
                    p.id = productId;
                    p.salePriceStr =  productPrice;
                    //p.product_image = product.image;
                    mainView.qmlActionSlot(MainFlow.QML_SQL_PRODUCT_CREATE,productId);
                    rect_window.visible = false
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
                rect_window.visible = false
            }
        }
    }





    function productInfoFlush(p){
        console.log("刷新商品信息" + p);

    }




}

