import QtQuick 1.1
import "MTColumn" as MTColumn
import "./MTColumn/Column.js" as Column
Rectangle {
    id:window
    width: 100
    height: 62
    visible: false
    // 2.货道管理展示区域

    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        anchors{
            top:parent.top
            topMargin: 0
        }
        z:5
        border{
            color: "gray"
            width: 1
        }
        Text {
            width: parent.width * 0.4
            height: parent.height
            anchors{
                left: parent.left
                leftMargin: 5
            }
            horizontalAlignment: Text.AlignLeft
            verticalAlignment: Text.AlignVCenter
            text: qsTr("货道管理")
            font{
                bold: true
                pixelSize: 20
            }
        }
    }


    //主界面区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.95
        anchors{
            top:title.bottom
        }
        //主界面
        Rectangle {
            id: listView_rect
            anchors.fill: parent
            z:3
            Rectangle{
                id:cabinet_rect
                width: parent.width
                height: parent.height * 0.95
                anchors.top:parent.top
                z:1
                ListView{
                    id:listView
                    anchors.fill: parent
                    model: listModel
                    delegate:list_delegate
                    snapMode: ListView.SnapToItem
                    spacing: 1
                    orientation: ListView.Horizontal
                    boundsBehavior: Flickable.StopAtBounds
                    flickDeceleration: 5000  //滑动速度
                    onMovementEnded:{
                        console.log("onMovementEnded--触发");
                        var i = indexAt(contentX,contentY);
                        if(i != -1 && i != listView.currentIndex){
                            listView.currentIndex = i;
                        }
                    }
                    onMovementStarted: {
                        console.log("onMovementStarted--触发");
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
                        property int num: num
                    }
                }

            }

            //工具栏界面
            Rectangle{
                id:go_rect
                width: parent.width
                height: parent.height * 0.05
                anchors{
                    bottom: parent.bottom
                }
                z:3
                //color: "transparent"
                color:"gray"
                visible: true
                Row{
                    anchors.centerIn: parent
                    spacing: 10
                    Image {
                        id: go_previous_image
                        source: "../../images/tool/go-previous.png"
                    }
                    Text {
                        id: go_text
                        text: (listView.currentIndex + 1) + "/" + listView.count
                        font{
                            bold: true
                            pixelSize: go_rect.width * 0.08
                        }
                        color: "blue"
                    }
                    Image {
                        id: go_next_image
                        source: "../../images/tool/go-next.png"
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
        }
    }





    function createCabinet(no){
        if(listView.count < no){
            listModel.append({"num":no})
            listView.cacheBuffer += listView.width
            console.log("创建柜子 count="  + listModel.count + " cacheBuffer:" +
                        listView.cacheBuffer)
        }

        listView.currentIndex = no - 1;
        return listView.currentItem;
    }


    function columnCreate(obj){
        console.log("货道列表模型" + "obj="+ obj + " count=" + obj.size);
        for(var i = 0;i < obj.size;i++){
            var col = obj.at(i);
            console.log("提取货道" + "col=" + col + " id=" + col.id);
            var cabinet = createCabinet(col.bin);
            var column = cabinet.vmCreateColumn(col.column);
            column.column_id = col.column;
            column.column_state = col.state;
        }
        obj.queueClear();
    }

    function columnClear(){
        product_model.clear();
    }

}

