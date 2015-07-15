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
    property alias in_bin: input_bin.text_contex
    property alias in_column: input_column.text_contex
    property alias in_remain: input_remain.text_contex
    property alias in_total: input_total.text_contex
    property alias in_goods: input_goods.text_contex
    property alias in_image: product_image.source
    property alias in_goods_name: product_text.text
    property bool isCreate:false
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
                    text_title:"货道号:"
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                    text_contex: ""
                }
                VMCoumnTextInput{
                    id:input_remain
                    width: parent.width
                    height: parent.height * 0.15
                    text_title:"剩余量:"
                    text_contex: ""
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
                }
                VMCoumnTextInput{
                    id:input_total
                    width: parent.width
                    height: parent.height * 0.15
                    text_title:"总容量:"
                    text_contex: ""
                    validator:DoubleValidator{decimals: 0; bottom: 0; top: 100; notation:DoubleValidator.StandardNotation}
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
                column.col_bin = in_bin;
                column.col_column = in_column;
                column.col_goods = in_goods;
                column.col_remain = in_remain;
                column.col_total = in_total;
                if(column.col_remain == 0){
                   if(column.col_state == VmcMainFlow.EV_COLUMN_NORMAL){
                       column.col_state = VmcMainFlow.EV_COLUMN_EMPTY;
                   }
                }
                else{
                    if(column.col_state == VmcMainFlow.EV_COLUMN_EMPTY){
                        column.col_state = VmcMainFlow.EV_COLUMN_NORMAL;
                    }
                }
                vm.qmlActionSlot(MainFlow.QML_SQL_COLUMN_CHANGE,column);
                hide();
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

        var item = sqlProductList.get(col.col_goods);
        if(item){
            in_image =  vmConfig.qmlPath() +  item.pic;
            in_goods_name = item.name;
        }

        rect.visible = true;
    }






}

