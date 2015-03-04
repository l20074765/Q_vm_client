import QtQuick 1.1

//标题栏
Rectangle{
    id:title_rect
    width: parent.width
    height: parent.height*0.05
    anchors{top:parent.top}
    signal remain_timer_timeout()
    property int remain_time: 120
    property bool remain_time_show: false
    Image {
        id: title_image
        width: parent.width
        height: parent.height
        anchors.fill: parent
        source: "../../images/tool/topbg.png"
        rotation: 0

    }
    Text{
        width: 50
        height: 20
        anchors{
            verticalCenter: parent.verticalCenter
            left:parent.left
            leftMargin: 5
        }
        font.bold: true
        font.pixelSize: parent.height * 0.5
        color: "#FFFFFF"
        text:"欢迎光临 by yoc"
    }


    Text {
        id: title_timer_text
        width: parent.width * 0.1
        height: parent.height
        anchors{
            right: parent.right
            rightMargin: 5
            verticalCenter: parent.verticalCenter
        }

        font.bold: true
        font.pixelSize: parent.height * 0.5
        color: "#FFFFFF"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        text:remain_time.toString();
        visible: remain_time_show
    }
    //定时器
    Timer{
        id:title_timer
        interval: 1000; running: false; repeat: true;
        onTriggered: {
            if(remain_time)
                remain_time--;
            else
                remain_timer_timeout();

        }
    }


    function title_flush(){
        remain_time = 120;
    }

    function title_timer_set(s){
        if(s == 1){
            title_flush();
            title_timer_text.visible = true;
            title_timer.start();
        }
        else{
            title_timer.stop()
            title_timer_text.visible = false;
        }


    }

}

