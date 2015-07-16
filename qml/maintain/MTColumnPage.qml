import QtQuick 1.1
import "MTColumn" as MTColumn
import "MainTain.js" as MainTainJs
import "./MTColumn/Column.js" as Column
Rectangle {
    id:rect_columnPage
    width: 100
    height: 62
    property Item cabinetEditItem:null
    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        anchors{top:parent.top;topMargin: 0}
        z:5
        border{color: "gray"; width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("货道管理")
            font.pixelSize: (parent.height < parent.width) ? parent.height * 0.5: parent.width * 0.1;
            font{bold: true;}
        }

        MTColumn.MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            text: "删除该柜"
            onClicked: {
                if(listView.currentItem){
                    //var sum = listModel.count;

                }
            }
        }


        MTColumn.MyButton{
            width: parent.width * 0.2
            height:parent.height * 0.8
            anchors{
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            font{
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            text: "新增货柜"
            onClicked: {
                var item = mtGetCabinetEditItem();
                item.visible = true;

            }
        }


    }
    // 2.货道管理展示区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.9
        z:3
        anchors{top:title.bottom}
        //主界面
        Rectangle {
            id: listView_rect
            anchors.fill: parent

            ListView{
                id:listView
                anchors.fill: parent
                model: listModel
                delegate:list_delegate
                snapMode: ListView.SnapToItem
                spacing: 1
                flickDeceleration: 5000  //滑动速度
                highlightMoveSpeed:2000  //滚动速度
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.DragAndOvershootBounds
                focus: true
                onMovementEnded:{
                    console.log("onMovementEnded:");
                    var i = indexAt(contentX,contentY);
                    if(i != -1 && i != listView.currentIndex){
                        listView.currentIndex = i;
                    }
                }
            }
            ListModel{
                id:listModel


            }
            Component{
                id:list_delegate
                MTColumn.VMCabinet{
                    width: listView.width
                    height: listView.height
                    cabinetNo: cabinet_no
                    topParent:  top_parent
                }
            }

        }
    }

    //3. 工具栏界面
    Rectangle{
        width: parent.width
        height: parent.height * 0.05
        anchors{bottom: parent.bottom}
        z:5
        Rectangle{
            id:go_rect
            width: parent.width * 0.5
            height: parent.height * 0.75
            anchors.centerIn: parent
            visible: true
            Row{
                width: parent.width
                height: parent.height
                anchors.centerIn: parent
                spacing: 10
                Rectangle{
                    id: go_previous_image
                    width: parent.width * 0.3
                    height: parent.height * 0.9
                    border{width: 2;color: "gray"}
                    Text {
                        anchors.centerIn: parent
                        text: "上一页"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            listView.decrementCurrentIndex();
                        }
                    }
                }
                Text {
                    id: go_text
                    width: parent.width * 0.2
                    height: parent.height * 0.9
                    text: (listView.currentIndex + 1) + "/" + listView.count
                    font{
                        bold: true
                        pixelSize: go_rect.height
                    }
                    color: "blue"
                }

                Rectangle{
                    id: go_next_image
                    width: parent.width * 0.3
                    height: parent.height * 0.9
                    border{width: 2;color: "gray"}
                    Text {
                        anchors.centerIn: parent
                        text: "下一页"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            listView.incrementCurrentIndex();
                        }
                    }
                }

            }
            Timer{
                id:go_timer
                interval: 3000; running: false; repeat: true
                onTriggered:{
                    go_timer.stop();
                    go_rect.visible = false;
                }
            }
        }

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
                rect_columnPage.visible = false
            }
        }
    }



    function createCabinet(no){

        listModel.append({"cabinet_no":no,
                            "top_parent":rect_columnPage})
        listView.cacheBuffer += listView.width
        console.log("创建柜子 count="  + listModel.count + " cacheBuffer:" +
                    listView.cacheBuffer)

        var index = listModel.count - 1;
        listView.currentIndex = index;
        return listView.currentItem;
    }


    function columnCreate(obj){
        console.log("货道列表模型" + "obj="+ obj + " count=" + obj.size);
        for(var i = 0;i < obj.size;i++){
            var col = obj.at(i);
            console.log("提取货道" + "col=" + col + " id=" + col.id);
            var cabinet = createCabinet(col.bin);
            var column = cabinet.vmCreateColumn(col.column);
            column.column_id = col.bin + "-" + col.column;
            column.column_state = col.state;
            column.column_column = col.column;
            column.column_bin = col.bin;
            column.column_remain = col.remain;
            column.column_total = col.total;
            column.column_goods = col.productNo;

        }
    }

    function columnClear(){
        product_model.clear();
    }


    function mtGetCabinetEditItem(){
        if(cabinetEditItem == null){
            cabinetEditItem =  MainTainJs.loadComponent(rect_columnPage,"./MTColumn/MTCabinetEditPage.qml");
            cabinetEditItem.connectSignal();
        }
        return cabinetEditItem;
    }

}

