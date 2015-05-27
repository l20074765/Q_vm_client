import QtQuick 1.0

Rectangle {
    signal goods_clicked
    property int productIndex: 0
    property string productName: "商品名称"
    property string productPrice: "0.00"
    property string productImage:"../../images/product/default_product.png"
    property string productID:"jp0001"
    property int borderMargin: 2
    width: 350
    height: 450
    radius: 5
    border{
     width: borderMargin
     color: "#bc6ca8"
    }
    smooth: true


    //图片显示区域
    Image {
        id: pic_image
        width:  (parent.width- borderMargin * 2) * 0.7
        height: (parent.height- borderMargin * 2) * 0.7

        anchors{
            top:parent.top
            topMargin: (parent.height - borderMargin * 2) * 0.03
            horizontalCenter: parent.horizontalCenter

        }
        smooth: true
        source: productImage
        //fillMode:Image.PreserveAspectCrop
        //clip: true
        fillMode: Image.PreserveAspectFit

    }

    //商品信息区域
    Rectangle{
        id:picInfo_rect
        width: parent.width - borderMargin * 2
        height: (parent.height - borderMargin * 2) * 0.2
        anchors{
            bottom:parent.bottom
            bottomMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        Column{
           anchors.fill: parent
           spacing: 5
           Text {
               id: pic_name
               anchors{horizontalCenter: parent.horizontalCenter}
               font{
                  bold: true
                  pixelSize: (parent.width < parent.height) ?
                               parent.width * 0.2 : parent.height * 0.35
               }
               horizontalAlignment: Text.AlignHCenter
               text: productName

           }
           Text {
               id: pic_price
               anchors{
                   horizontalCenter:   parent.horizontalCenter}
               font{
                  bold: true
                  pixelSize: (parent.width < parent.height) ?
                               parent.width * 0.2 : parent.height * 0.35
               }
               horizontalAlignment: Text.AlignHCenter
               text: qsTr("单价:") +  productPrice + qsTr("元")

           }
        }


    }


    MouseArea{
        hoverEnabled: false
        anchors.fill: parent
        onClicked: goods_clicked()
    }
}

