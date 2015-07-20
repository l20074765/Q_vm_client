import QtQuick 1.1
import "../custom" as Custom
import "../custom/CreateQml.js" as CreateQml


Custom.VMWidget {
    id:widget
    width: 100
    height: 62

    property Item vmPayPage: null

    MouseArea{anchors.fill: parent} //mask
    //标题栏区域
    Custom.VMTitlebar{
        id:title_bar
        width: parent.width
        height: parent.height * parent.titleHR
        anchors{top:parent.top}
        title: "请选择支付方式"
    }

    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * parent.rectHR
        anchors{top:title_bar.bottom}
        Grid{
            width: parent.width * 0.9
            height:parent.height * 0.45
            anchors.centerIn: parent
            columns: 3
            spacing: width * 0.05

            Image {
                width: parent.width * 0.3
                height: parent.height * 0.2
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../../images/tool/cash_button.png"
            }
            Image {
                width: parent.width * 0.3
                height: parent.height * 0.2
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../../images/tool/alipay_button.png"
            }
            Image {
                width: parent.width * 0.3
                height: parent.height * 0.2
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../../images/tool/alipayqre_button.png"
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        var page = vmGetPayPage();
                        page.show();
                    }
                }
            }
            Image {
                width: parent.width * 0.3
                height: parent.height * 0.2
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../../images/tool/pos_button.png"
            }
            Image {
                width: parent.width * 0.3
                height: parent.height * 0.2
                smooth: true
                fillMode: Image.PreserveAspectFit
                source: "../../images/tool/weixin_button.png"
            }
        }
    }


    //状态栏区域
    Custom.VMStatusbar{
        id:status_bar
        width: parent.width
        height: parent.height * parent.statusHR
        z:5
        anchors{top:main_rect.bottom}
        onStatus_back_clicked: {
             back_return();
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

    function back_return(){
        console.log("返回" +widget.parent );
        widget.hide();
        vm_main.timer_flush(120);
        vm_main.timer_start();
    }
}

