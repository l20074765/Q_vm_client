import QtQuick 1.1
import "MainTain.js" as MainTainJs
import "./MTColumn" as MTColumn

Rectangle {
    id:root
    width: 100
    height: 62
    transformOrigin: Item.Center //转换起点 中心 即不转换
    //color: "red"
    visible: false
    property int duration : 500
    property string pic_path_str: "../../images/productPic/"
    property bool isGetPic: false


    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        z:9
        anchors{top:parent.top}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("图片浏览")
            font{
                bold: true
                pixelSize: (parent.height < parent.width) ?
                             parent.height * 0.5: parent.width * 0.1;
            }
        }
    }

    Rectangle{
        width: parent.width
        height: parent.height * 0.9
        anchors.top: rect_title.bottom
        z:2
        //定义列表组件
        Component{
            id:product_delegate
            Rectangle{
                property alias productName: p_text.text
                property alias productImage:  p_image.source

                width: product_gridView.cellW
                height:product_gridView.cellH
                Rectangle{
                    width: parent.width * 0.9
                    height: parent.height * 0.9
                    Column{
                        anchors.fill: parent
                        spacing: 4
                        Image{
                            id:p_image
                            width: parent.width
                            height: parent.height * 0.8
                            smooth: true
                            source: product_image
                            fillMode: Image.PreserveAspectFit
                        }
                        Text {
                            id:p_text
                            width: parent.width
                            height: parent.height * 0.2
                            anchors.horizontalCenter: parent.horizontalCenter
                            smooth: true
                            text: product_name
                            font{
                                pixelSize: (height < width) ?
                                               height * 0.4 : width * 0.06;
                            }
                            elide: Text.ElideRight
                            horizontalAlignment: Text.AlignHCenter
                        }

                    }

                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            var item = parent.parent
                            console.log("Item=" + item + " parent:" + root.parent);
                            var item1 = product_gridView.childAt(mouseX,mouseY);
                            console.log("item1=" + item1);
                            console.log("listModel:count=" + product_model.count );

                            if(root.parent){
                                if(root.parent.productName == ""){
                                    root.parent.productName = item.productName
                                }
                                root.parent.productPic =item.productImage
                                console.log("选中商品图片路径:" + item.productImage);
                            }
                            save();

                        }
                    }
                }


            }
        }

        ListModel{
            id:product_model
        }

        //商品列表框
        GridView{
            id:product_gridView
            width: parent.width
            height: parent.height
            anchors.centerIn: parent
            property real cellW: (width) / 4.02
            property real cellH: (height) / 4.4
            cellWidth: cellW
            cellHeight: cellH

            flickableDirection:Flickable.VerticalFlick
            delegate: product_delegate
            model: product_model
            focus: true
            currentIndex: 1
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
        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            font{
                bold: true
                pixelSize: (height < width) ?
                               height * 0.6 : width * 0.1;
            }
            onClicked: {
                root.hide();
            }
        }
    }


    function vmCreateProduct(name){
        var picName = name.split('.');
        var path = vmConfig.productPicPath();
        product_model.append({
                          "product_name":picName[0],
                          "product_image":path + "/" + name
                         });
        var product = product_model.get(product_model.count - 1);
        return product;
    }



    function mtProductClear(){
        product_model.clear();
    }


    function save(){
        hide()
    }

    function show(){
        reset();
        animBig.start();
     }
    function hide(){
        animSmall.start();
    }
    function reset(){
        root.scale = 1;
        root.visible = true;
        if(!isGetPic){
            //isGetPic = true;
            mtProductClear();
            var path = vmConfig.productPicPath();
            var picList = vmConfig.getFilePicList(path);
            for(var i = 0;i < picList.length;i++){
                var pic = vmCreateProduct(picList[i]);
            }
        }


    }

    // 立即关闭
    function close(){
      console.log("图片浏览器关闭");
      root.visible = false;
    }

    // 禁止事件穿透
    MouseArea{
      anchors.fill: parent;
      onPressed:{
          // mouse.accepted = true
      }
      //drag.target: root  // root可拖动
    }

    //------------------------------
    // 动画
    //------------------------------
    PropertyAnimation {
        id: animBig
        target: root
        duration: root.duration
        easing.type:  Easing.OutBounce
        property: 'scale';
        from: 0;
        to: 1
    }
    PropertyAnimation {
        id: animSmall
        target: root
        duration: root.duration
        easing.type: Easing.OutBounce
        property: 'scale';
        from: 1;
        to: 0
        onCompleted: {
            close()
        }
    }
}

