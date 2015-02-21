import QtQuick 1.0

VMWidget {
    signal button_pay_clicked //定义购买按钮信号
    onVisibleChanged: {
    }
    anchors.fill: parent
    Rectangle{
        id:productInfo_rect
        anchors{
         top:parent.top
         topMargin: 5
         left: parent.left
         leftMargin:5
         horizontalCenter: parent.horizontalCenter
        }
        width: parent.width
        height:parent.height * 0.4

        //商品描述区
        Row{
            anchors{
                top:parent.top
                topMargin: 5
            }

            spacing: 5
            Product{
                id:product1
                width: 350 * 0.5
                height: 450 * 0.5
                large: true


            }
            Rectangle{
                width:350 * 0.5
                height: 450 * 0.5
                Text {
                    id: productName
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.bold: true
                    font.pixelSize: parent.width * 0.2
                    text: product1.productName

                }

                //商品名称
                Text {
                    id: productPrice
                    anchors.top:productName.bottom
                    anchors.horizontalCenter: parent.horizontalCenter

                    text: qsTr("商品单价:") + product1.productPrice +qsTr("元")
                }
                //商品名称
                Text {
                    id: productInfo
                    anchors.top:productPrice.bottom
                    anchors.horizontalCenter: parent.horizontalCenter
                    text: qsTr("商品详细")
                }

            }
        }
    }

    //购买区域
    Rectangle{
        id:pay_rect
        anchors{
           top:productInfo_rect.bottom
        }
        width: parent.width
        height: parent.height * 0.5
        Image {
            id:pay_image
            width: 140
            height: 46
            anchors{
                right: parent.right
                rightMargin:10
            }
            source: "../images/product/goumai.png"
            fillMode: Image.PreserveAspectCrop
            clip:true

            MouseArea{
                id:pay_mouse
                width: parent.width
                height:parent.height
                onClicked: {
                    console.log("onClicked: ")
                    button_pay_clicked()
                }
            }
        }

    }




    function setGoodsInfo(p){
        product1.productName =p.product_name
        product1.productPrice = p.product_price
        productName.text = p.product_name
    }

}
