import QtQuick 1.0

Rectangle {
    signal goods_clicked
    property int productIndex: 0
    property string productName: "商品名称"
    property string productPrice: "0.00"
    property string productImage:"../../images/product/default_product.png"
    property string productID:"jp0001"
    property bool large: false  //是否显示大图片
    property int borderMargin: 2

    width: 350*0.20
    height: 450*0.20
    border{
     width: borderMargin
     color: "gray"
    }


    //图片显示区域
    Image {
        id: pic_image
        width: large ? (parent.width - borderMargin * 2) :  (parent.width- borderMargin * 2) * 0.65
        height: large ? (parent.height - borderMargin * 2) :  (parent.height- borderMargin * 2) * 0.65
        anchors{
            top:parent.top
            topMargin: large ? 0 : (parent.height - borderMargin * 2) * 0.03
            horizontalCenter: parent.horizontalCenter

        }
        source: productImage
        fillMode: Image.PreserveAspectCrop
        clip: true
    }

    //商品信息区域
    Rectangle{
        id:picInfo_rect
        width: parent.width - borderMargin * 2
        height: (parent.height - borderMargin * 2) * 0.2
        anchors{
            top:pic_image.bottom
            topMargin: (parent.height - borderMargin * 2) * 0.02
            horizontalCenter:   pic_image.horizontalCenter
        }
        visible: large ? false:true
        Text {
            id: pic_name
            width: parent.width
            height: parent.height * 0.4
            anchors{
                top:parent.top
                topMargin: parent.height * 0.03
                horizontalCenter:   parent.orizontalCenter
            }
            font{
               bold: true
               pixelSize: parent.width * 0.12
            }
            horizontalAlignment: Text.AlignHCenter
            text: productName

        }

        Text {
            id: pic_price
            width: parent.width
            height: parent.height * 0.4
            anchors{
                bottom: parent.bottom
                bottomMargin: parent.height * 0.02
                horizontalCenter:   parent.horizontalCenter

            }
            font{
               bold: true
               pixelSize: parent.width * 0.12
            }
            horizontalAlignment: Text.AlignHCenter
            text: qsTr("单价:") +  productPrice + qsTr("元")

        }

    }


    MouseArea{
        hoverEnabled: false
        anchors.fill: parent
        onClicked: goods_clicked()
    }
}

