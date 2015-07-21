import QtQuick 1.1

//标题栏
Rectangle{
    id:title_rect
    width: parent.width
    height: parent.height*0.05
    anchors{top:parent.top}
    property alias title: title_text.text
    property int tick:0
    signal timerout()
    MouseArea{anchors.fill: parent} //mask
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
        id:title_text
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
        id: timer_text
        width: parent.width * 0.2
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
        text:"剩余:" + tick
        visible: (tick > 0) ? true : false
    }


    //定时器
    Timer{
        id:timer
        interval: 1000; running: false; repeat: true;
        onTriggered: {
            if(tick){
                tick--;
            }
            else{
                timer.stop();
                timerout();
            }
        }
    }

    function timer_flush(t){
        tick = t;
    }

    function timer_start(){
        timer.start();
    }

    function timer_stop(){
        timer.stop();
    }



}

