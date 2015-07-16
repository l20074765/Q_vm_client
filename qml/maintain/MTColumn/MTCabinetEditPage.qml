import QtQuick 1.1
import "../../custom"  as Custom
import "../MainTain.js" as MainTainJs
import Qtvm 1.0

Rectangle {
    id:rect_cabinetEditPage
    width: 100
    height: 62
    property int no: 0
    property int sum:80
    property int type:1
    property alias cabinetNo: cabinet_id.text_contex
    property alias colSum: cabinet_sum.text_contex
    property string info:""
    property Item loadingMask:null
    MouseArea{ //禁止事件穿透
        anchors.fill: parent
    }
    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        z:2
        anchors{top:parent.top}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("编辑货柜")
            font{
                bold: true
                pixelSize: (parent.height < parent.width) ? parent.height * 0.5: parent.width * 0.1;
            }
        }
        MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                pixelSize: (height < width) ?height * 0.6 : width * 0.1;
            }
            text: "删除商品"
            onClicked: {
                 hide();
            }
        }

    }

    //2 商品图片区
    Rectangle{
        width: parent.width
        height: parent.height * 0.9
        z:2
        anchors{top:rect_title.bottom;topMargin: 1;}

        Column{
            width: parent.width
            height: parent.height * 0.6
            anchors.top: parent.top
            anchors.topMargin: 20
            spacing: 10
            VMCoumnTextInput{
                id:cabinet_id
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("货柜编号:")
                text_contex: "1"
                validator:DoubleValidator{ decimals: 0; bottom: 0; top: 1000; notation:DoubleValidator.StandardNotation}
            }
            VMCoumnTextInput{
                id:cabinet_sum
                width: parent.width
                height: parent.height / 12
                text_title: qsTr("货道总数:")
                text_contex: "48"
                validator:DoubleValidator{ decimals: 0; bottom: 0; top: 1000; notation:DoubleValidator.StandardNotation}
            }
//            VMCoumnTextInput{
//                id:cabinet_price
//                width: parent.width
//                height: parent.height / 12
//                text_title: qsTr("货道类型:")
//                text_contex: "1"
//                validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
//            }
        }


    }




    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:2
        anchors{
            bottom: parent.bottom
        }
        smooth: true
        border{ color: "gray";width: 1 }

        MyButton{
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

                //创建货柜
                var cab = sqlCabinetList.create(rect_cabinetEditPage.cabinetNo);
                console.log("保存创建货柜" + "no=" + rect_cabinetEditPage.cabinetNo +" cab=" +  cab);
                if(cab == null){ //柜号重复
                    hide();
                }
                else{
                    console.log("后台创建货柜");
                    cab.sum = rect_cabinetEditPage.colSum;
                    mainView.qmlActionSlot(MainFlow.QML_SQL_CABINET_CREATE,rect_cabinetEditPage.cabinetNo);
                    loadingMask =  MainTainJs.loadComponent(rect_cabinetEditPage,"../../custom/LoadingMask.qml");
                    loadingMask.visible = true;
                }

            }
        }

        MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            font{
                bold: true
                pixelSize: (height < width) ?height * 0.6 : width * 0.1;
            }
            onClicked: {
                hide();
            }
        }
    }


    function flush(){
        console.log("flush");
    }

    function hide(){
        rect_cabinetEditPage.visible = false;
    }

    function loadingFinished(type,obj){
        console.log("货柜:测试qml信号" + "type=" + type+ " obj=" + obj);
        if(type == MainFlow.QML_SQL_CABINET_CREATE){
            rect_cabinetEditPage.loadingMask.destroy();
            var cabNo = rect_cabinetEditPage.cabinetNo;
            if(obj == 1){
                var cabinet = rect_cabinetEditPage.parent.createCabinet(cabNo);
                var cabinetCpp = sqlCabinetList.get(cabNo);
                var columnList = cabinetCpp.getColumnList();
                var size = columnList.size;
                console.log("需要创建货道数:" + size);
                for(var i = 0;i <= size;i++){
                    var col = columnList.at(i);
                    if(col){
                        cabinet.vmCreateColumnByColumn(col);
                    }
                }
            }
        }
        hide();

    }

    function connectSignal(){
        console.log("创建货柜编辑信号槽");
        vm_main.qmlMainSignal.connect(rect_cabinetEditPage.loadingFinished);
    }

}

