import QtQuick 1.1

//货道
Rectangle{
    id:id_rect
    property alias title_text: title.text
    property alias label_text: label.text
    property alias label_font: label.font
    color: "transparent"
    width: 100
    height: 150

    Text {id:title
        width: parent.width * 0.5
        height: parent.height
        anchors.left: parent.left
        anchors.leftMargin: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font{
            pixelSize:(width < height) ? width * 0.55 : height * 0.55;
            bold: false
        }
        color: "white"
        elide: Text.ElideMiddle
        text: "货道"
    }

    Text {id:label
        width: parent.width * 0.5
        height: parent.height
        anchors.right: parent.right
        anchors.rightMargin: 1
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        font{
            pixelSize:(width < height) ? width * 0.8 : height * 0.8;
            bold: true
        }
        color: "white"
        elide: Text.ElideMiddle
        text: "1"
    }
}
