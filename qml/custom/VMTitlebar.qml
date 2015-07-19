import QtQuick 1.1

//标题栏
Rectangle{
    id:title_rect
    width: parent.width
    height: parent.height*0.05
    anchors{top:parent.top}
    signal timeout()
    property int remain_time: 120
    property bool remain_time_show: false
    property alias title: text_title.text
    Image {
        id: title_image
        width: parent.width
        height: parent.height
        anchors.fill: parent
        smooth: true
        source: "../../images/tool/test1.png"
        rotation: 0

    }
    Text{
        id:text_title
        width: parent.width * 0.5
        height: parent.height * 0.8
        anchors{
            verticalCenter: parent.verticalCenter
            left:parent.left
            leftMargin: 5
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize: (width < height) ? width * 0.7 : height * 0.7
        color: "#FFFFFF"
        text:"欢迎光临"
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
        font.pixelSize: (width < height) ? width * 0.5 : height * 0.5
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
                timeout();

        }
    }


    function title_flush(){
        remain_time = 120;
    }

    function timer_set(s){
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

