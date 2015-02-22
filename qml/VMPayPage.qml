import QtQuick 1.0

VMWidget {
    id:vmPay_page
    anchors.fill: parent
    property string pic_image:"../images/alipay/code.png"
    Rectangle{
        id:goods_view_rect
        anchors{
            top:parent.top
        }
        width: parent.width
        height: parent.height * 0.5
        ListModel {
            id: fruitModel

        }
        Component {
           id: fruitDelegate
           Row {
               id: fruit
               spacing: 10
               Text {
                   font{
                       bold: true;
                       pixelSize:vmPay_page.width * 0.04

                   }
                   text: name
               }
               Text {
                   font{
                       bold: true;
                       pixelSize: vmPay_page.width * 0.04

                   }
                   text:cost
               }
           }
        }

        ListView {
            anchors.fill: parent
            model: fruitModel


            delegate: fruitDelegate
        }


    }

    //中间栏
    Rectangle{
        id:pay_bar_rect
        anchors{
            top:goods_view_rect.bottom
        }
        width: parent.width
        height: parent.height * 0.05
        Image {
            id: title_image
            width: parent.width
            height: parent.height
            anchors.fill: parent
            source: "../images/tool/topbg.png"
            rotation: 0

        }

        Text{
            width: 50
            height: 20
            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                leftMargin: 5
            }
            color: "#FFFFFF"
            font.bold: true
            font.pixelSize: parent.height * 0.5
            text:"支付流程"

        }


    }

    Rectangle{
        id:payView_rect
        anchors{
            top:pay_bar_rect.bottom
        }
        width: parent.width
        height: parent.height * 0.45
        //支付宝交易指导界面
        Image {
            id: payView_image
            anchors.fill: parent
            source: "../images/alipay/zf2.jpg"
            fillMode: Image.PreserveAspectCrop
            clip: true
        }

        Image {
            id: payqure_image//二维码图片
            x:payView_image.x + payView_image.width * 0.558
            y:payView_image.y + payView_image.height * 0.412
            width: payView_image.width * 0.225
            height: payView_image.height * 0.332
            source: pic_image
            fillMode: Image.PreserveAspectCrop
            clip: true
        }
    }


    function listViewClear(){
        fruitModel.clear();
    }


    function vmPayAddProduct(p){
        console.log("创建商品列表项UI id=" + p.product_id);
        fruitModel.append({"name":p.product_name,
                            "cost":p.product_price})
    }




}

