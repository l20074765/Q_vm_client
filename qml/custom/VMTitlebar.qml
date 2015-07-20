import QtQuick 1.1

//标题栏
Rectangle{
    id:title_rect
    width: parent.width
    height: parent.height*0.05
    anchors{top:parent.top}
    property alias title: title_text.text
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
        text:"剩余:" + vm_main.tick
        visible: (vm_main.tick > 0) ? true : false
    }
}

