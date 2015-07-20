import QtQuick 1.0
import "../custom" as Custom
import "../custom/CreateQml.js" as CreateQml
import Qtvm 1.0

Custom.VMWidget {
    id:widget
    signal button_pay_clicked() //定义购买按钮信号

    property Item product: null
    property alias productImage: product_image.source
    property alias productName: product_name.text
    property alias productPrice: product_price.text
    property Item vmPayPage: null
    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * parent.titleHR
        anchors{top:parent.top}
    }

    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * parent.rectHR
        anchors{top:title_bar.bottom}
        //商品放大区
        Image{
            id:product_image
            width: parent.width * 0.4
            height: parent.height * 0.4
            anchors{
                top:parent.top
                topMargin: 10
                left: parent.left
                leftMargin: 10
            }
            source: ""
            smooth: true
            fillMode: Image.PreserveAspectFit

        }

        Rectangle{
            id:product_rect
            width:  parent.width * 0.4
            height: parent.height * 0.4
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.right: parent.right
            anchors.rightMargin: 10
            Column{
                width: parent.width
                height: parent.height * 0.8
                anchors.centerIn: parent
                spacing: height * 0.01

                Text {
                    id: product_name
                    width: parent.width
                    height: parent.height * 0.2
                    horizontalAlignment: Text.AlignHCenter
                    font.bold: true
                    font.pixelSize: (width < height) ? width * 0.6: height * 0.6;
                    text: ""
                    elide: Text.ElideLeft

                }
                //商品名称
                Text {
                    id: product_price
                    width: parent.width
                    height: parent.height * 0.1
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: (width < height) ? width * 0.6: height * 0.6;
                    text: ""
                }
                //商品名称
                Text {
                    id: product_info
                    width: parent.width
                    height: parent.height * 0.6
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: (width < height) ? width * 0.1: height * 0.1;
                    text: ""
                }
            }
        }


        //购买区域
        Rectangle{
            id:pay_rect
            width: parent.width
            height: parent.height * 0.4
            anchors{
               top:product_rect.bottom
               topMargin: 10
            }

            Image {
                id:pay_image
                width: parent.width * 0.2
                height: parent.height * 0.2
                anchors{
                    right: parent.right
                    rightMargin:10
                }
                source: "../../images/product/goumai.png"
                fillMode: Image.PreserveAspectFit
                smooth: true

                MouseArea{
                    id:pay_mouse
                    width: parent.width
                    height:parent.height
                    onClicked: {
                        button_pay_clicked()
                        vm_main.timer_flush(120);
                        vm_main.timer_start();
                        var page = vmGetPayPage();
                        //vmPayPage.vmPayAddProduct(p);
                        //vmPayPage.payqurePicSet(0);
                        qmlActionSignal(MainFlow.QML_ACTION_ORDER_ADD,product.productID)
                        qmlActionSignal(MainFlow.QML_ACTION_TRADE,product.productID);
                        page.show();
                    }
                }
            }
        }
    }

    //状态栏区域
    Custom.VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height * parent.statusHR
        anchors{top:main_rect.bottom}
        onStatus_back_clicked: {
            back_return();
        }
    }


    function flush(p){
        if(p == null){
            console.log("p == null");
        }
        else{
            product = p;
            productImage = p.productImage;
            productName = p.productName;
            productPrice = "单价:"+ p.productPrice + "元" ;
        }
    }


    function vmGetPayPage(){
        if(vmPayPage == null){
            vmPayPage = CreateQml.loadComponent(widget,"VMPayPage.qml");
            //vmTransactionPage.back_clicked.connect(vmAdsPageSwitch);
            return vmPayPage;
        }
        else{
            return vmPayPage;
        }
    }

    function timer_out(){
        if(widget.visible == true){
            back_return();
        }
    }

    function back_return(){
        console.log("返回" +widget.parent );
        widget.hide();
        vm_main.timer_flush(120);
        vm_main.timer_start();
    }

}
