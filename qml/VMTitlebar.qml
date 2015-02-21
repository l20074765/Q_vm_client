import QtQuick 1.1

//标题栏
Rectangle{
    id:title_rect
    width: parent.width
    height: parent.height*0.05
    anchors{top:parent.top}
    Image {
        id: title_image
        width: parent.width
        height: parent.height
        anchors.fill: parent
        source: "../images/tool/topbg.png"
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

}

