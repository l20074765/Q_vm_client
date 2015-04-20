import QtQuick 1.1

//货道
Rectangle{
    id:id_rect
    property string text_title: "标题:"
    property string text_label: "内容"
    color: "transparent"
    width: 100
    height: 150
    Text {
        anchors.fill: parent
        anchors.leftMargin: 5
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font{
            pixelSize:12
            bold: true
        }
        color: "white"
        elide: Text.ElideMiddle
        text: text_label
    }
}
