import QtQuick 1.0

VMWidget {
    id:vmFault_page
    anchors.fill: parent
    //文本区
    TextEdit{
        id:text_edit
        width: parent.width
        height: parent.height*0.9
        anchors{top:parent.top}
        Text{
            text:"本机故障\n暂停服务"
            font.bold: true
            font.pixelSize: parent.width * 0.1
        }
    }


}

