import QtQuick 1.1
import "Column.js" as Column
import "../MainTain.js" as  MainTainJs
import Qtvm 1.0

Rectangle {
    id:rect
    width: 300
    height: 162
    property Item parentItem
    property Item column:null
    property Item loadingMask: null
    property alias in_bin: input_bin.text_contex
    property alias in_column: input_column.text_contex
    property alias in_remain: input_remain.text_contex
    property alias in_total: input_total.text_contex
    property alias in_goods: input_goods.text_contex
    property alias in_image: product_image.source
    property alias in_goods_name: product_text.text
    property alias in_state: input_state.text_contex
    property bool isCreate:false
    property int intRemain: 0
    property int intTotal: 0
    property int in_id: 0
    property int temp32: 0
    focus: true
    color: "white"
    opacity: 0.9
    MouseArea{ //覆盖一层鼠标区域 实现模态
        anchors.fill: parent
    }
    //标题栏
    Rectangle{
        id:title_rect
        width: parent.width
        height: parent.height * 0.05
        anchors.top:parent.top
        anchors.topMargin:0
        border{
            width: 2
            color:"gray"
        }

        Text{
            anchors.centerIn: parent
            font.pixelSize: (parent.height < parent.width) ? parent.height * 0.5: parent.width * 0.1;
            font.bold: true
            text: "货道编辑"
        }
    }

    //正文区
    Rectangle{
        id:text_rect
        width: parent.width
        height:parent.height * 0.9
        anchors.top:title_rect.bottom

        //2 商品图片区
        Rectangle{
            id:rect_productImage
            width: parent.width * 0.45
            height: parent.height * 0.35

            anchors{top:parent.top;topMargin: 10;
                    left: parent.left;leftMargin: 10}
           // border{color: "blue";width: 1}
            smooth: true
            Column{
                width: parent.width
                height: parent.height
                anchors.fill: parent
                spacing: 5

                Image{
                    id:product_image
                    width: parent.width
                    height: parent.height * 0.8
                    source: ""
                    smooth: true
                    fillMode: Image.PreserveAspectFit
                }
                Text{
                    id:product_text
                    width: parent.width
                    height: parent.height * 0.2
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font{
                        bold:true
                        pixelSize: (width < height) ? width * 0.4: height * 0.4;
                    }
                    elide:Text.ElideRight
                    text:""
                    smooth: true
                }

            }


        }





        MyButton{
            id:goodsBind
            width: parent.width * 0.15
            height: parent.width * 0.15
            anchors{
                right: parent.right
                rightMargin: parent.width * 0.025
                bottom: column_rect.top
                bottomMargin: 10
            }
            text: "绑定商品"
            font{
                bold: true
                pixelSize: width * 0.16
            }
            onClicked: {
                var  productPage =  MainTainJs.loadComponent(rect_mainTain,"VMProductBrowsePage.qml");
                if(productPage){
                    productPage.productFlush(rect);
                    productPage.visible = true;
                }

            }
        }


        MyButton{
            width: parent.width * 0.15
            height: parent.width * 0.15
            anchors{
                right: parent.right
                rightMargin: parent.width * 0.025
                top: parent.top
                topMargin: 10
            }
            text: "解除绑定"
            font{
                bold: true
                pixelSize: width * 0.16
            }
            onClicked: {
                in_goods = "";
                in_goods_name = "";
                in_image = "";
            }
        }

        //货道编辑区
        Rectangle{
            id:column_rect
            width: parent.width
            height: parent.height * 0.4
            anchors.top: rect_productImage.bottom
            anchors.topMargin: 10
            Column{              
                anchors.fill: parent
                spacing: 5
                VMCoumnTextInput{
                    id:input_bin
                    width: parent.width
                    height: parent.height * 0.15
                    text_title:"货柜号:"
                    text_contex: ""
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                    readOnly:true
                }
                VMCoumnTextInput{
                    id:input_column
                    width: parent.width
                    height: parent.height * 0.15
                    readOnly:true
                    text_title:"货道号:"
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                    text_contex: ""
                }
                VMCoumnTextInput{
                    id:input_remain
                    width: parent.width
                    height: parent.height * 0.15
                    numberOpen: true
                    text_title:"剩余量:"
                    text_contex: ""
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                    onAddSignal: {
                        intRemain = in_remain;
                        intTotal = in_total;
                        if(intRemain < intTotal){
                            in_remain++;
                        }
                    }
                    onSubSignal: {
                        if(in_remain > 0){
                            in_remain--;
                        }
                    }
                }
                VMCoumnTextInput{
                    id:input_total
                    width: parent.width
                    height: parent.height * 0.15
                    text_title:"总容量:"
                    numberOpen: true
                    text_contex: ""
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                    onAddSignal: {
                        in_total++;
                    }
                    onSubSignal: {
                        if(in_total > 0){
                            in_total--;
                            intRemain = in_remain;
                            intTotal = in_total;
                            if(intRemain > intTotal){
                                in_remain = in_total;
                            }
                        }
                    }

                }
                VMCoumnTextInput{
                    id:input_goods
                    width: parent.width
                    height: parent.height * 0.15
                    text_title:"商品号:"
                    text_contex: ""
                    onActiveFocused: {
                        var  productPage =  MainTainJs.loadComponent(rect_mainTain,"VMProductBrowsePage.qml");
                        if(productPage){
                            productPage.productFlush(rect);
                            productPage.visible = true;
                        }
                    }
                }VMCoumnTextInput{
                    id:input_state
                    width: parent.width
                    height: parent.height * 0.15
                    visible: false
                    text_title:"状态:"
                    text_contex: ""
                    onActiveFocused: {

                    }
                }
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

        MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.centerIn: parent
            text: "保存"
            font{
                bold: true
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            onClicked: {
                in_id = in_bin;
                temp32 =  in_column;
                in_id = in_id * 1000 + temp32;
                console.log("qml:货道更改保存:id="+in_id);
                var cpp_col = sqlCabinetList.getColumn(in_id);
                if(cpp_col){
                    //cpp_col.state =
                    cpp_col.remain = in_remain;
                    cpp_col.total = in_total;
                    cpp_col.productNo = in_goods;
                    if(in_remain == 0){
                       if(in_state == VmcMainFlow.EV_COLUMN_NORMAL){
                           cpp_col.state = VmcMainFlow.EV_COLUMN_EMPTY;
                       }
                    }
                    else{
                        if(in_state == VmcMainFlow.EV_COLUMN_EMPTY){
                            cpp_col.state = VmcMainFlow.EV_COLUMN_NORMAL;
                        }
                    }



                    vm.qmlActionSlot(MainFlow.QML_SQL_COLUMN_UPDATE,in_id);
                    loadingMask =  MainTainJs.loadComponent(rect_columnPage,"../../custom/LoadingMask.qml");
                    loadingMask.visible = true;
                }
                else{
                    console.log("qml:货道不存在!");
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
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            onClicked: {
                hide();
            }
        }
    }


    function hide(){
        rect.destroy();
    }

    function flush(col){
        console.log("货道编辑刷新属性");
        column = col;
        rect.in_bin = col.col_bin;
        rect.in_column = col.col_column;
        rect.in_goods = col.col_goods;
        rect.in_remain = col.col_remain;
        rect.in_total = col.col_total;
        rect.in_state = col.col_state;
        var item = sqlProductList.get(col.col_goods);
        if(item){
            in_image =  vmConfig.qmlPath() +  item.pic;
            in_goods_name = item.name;
        }

        rect.visible = true;
    }


    function loadingFinished(type,obj){
        console.log("槽[ColumnEdit]:qml信号" + "type=" + type+ " obj=" + obj);
        if(type == MainFlow.QML_SQL_COLUMN_UPDATE){
            var  cpp_col = sqlCabinetList.getColumn(in_id);
            if(cpp_col){
                column.col_bin = cpp_col.bin;
                column.col_column = cpp_col.column;
                column.col_goods = cpp_col.productNo;
                column.col_remain = cpp_col.remain;
                column.col_total = cpp_col.total;
                column.col_state = cpp_col.state;
            }
            loadingMask.destroy();

        }

        vm_main.qmlMainSignal.disconnect(rect.loadingFinished);
        hide();
    }






}

