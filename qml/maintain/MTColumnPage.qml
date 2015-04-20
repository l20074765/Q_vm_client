import QtQuick 1.1
import "MTColumn" as MTColumn
import "./MTColumn/Column.js" as Column
Rectangle {
    id:window
    width: 100
    height: 62
    visible: false
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
            font{bold: true;pixelSize: 20}
        }
    }
    // 2.货道管理展示区域
    Rectangle{
        id:main_rect
        width: parent.width
        height: parent.height * 0.9
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
                orientation: ListView.Horizontal
                boundsBehavior: Flickable.StopAtBounds
                flickDeceleration: 5000  //滑动速度
                onMovementEnded:{
                    var i = indexAt(contentX,contentY);
                    if(i != -1 && i != listView.currentIndex){
                        listView.currentIndex = i;
                    }
                }
                onMovementStarted: {
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
            height: parent.height * 0.8
            anchors.centerIn: parent
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
                        pixelSize: go_rect.height
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
        MTColumn.MyButton{
            width:parent.width * 0.2
            height: parent.height * 0.8
            anchors.right: parent.right
            anchors.rightMargin: 10
            text: "返回"
            onClicked: {
                window.visible = false;
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

}

