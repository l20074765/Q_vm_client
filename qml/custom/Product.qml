import QtQuick 1.0

Rectangle {
    id:rect_product
    signal goods_clicked
    property int productIndex: 0
    property string productName: "商品名称"
    property string productPrice: "0.00"
    property string productImage:""
    property string productID:"jp0001"
    property int borderMargin: 2
    property alias product: rect_product
   // property alias mouseX: mouse_goods.mouseX
    //property alias mouseY: mouse_goods.mouseY
    width: 350
    height: 450
    Rectangle{
        width: parent.width * 0.95
        height: parent.height * 0.95
        anchors.centerIn: parent
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
                   width: parent.width
                   anchors{horizontalCenter: parent.horizontalCenter}
                   font{
                      bold: true
                      pixelSize: (parent.width < parent.height) ?
                                   parent.width * 0.2 : parent.height * 0.35
                   }
                   horizontalAlignment: Text.AlignHCenter
                   elide: Text.ElideRight
                   text: productName

               }
               Text {
                   id: pic_price
                   width: parent.width
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
            id:mouse_goods
            hoverEnabled: false
            anchors.fill: parent
            onClicked: goods_clicked()
        }

    }

}

