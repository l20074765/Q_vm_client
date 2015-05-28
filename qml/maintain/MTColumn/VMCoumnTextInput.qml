import QtQuick 1.1
import "../../custom" as Custom

Rectangle{
    width: 100
    height: 40
    property alias text_title: test.text
    property alias text_contex:editor.text
    property alias readOnly: editor.readOnly
    border{
        width: 1
        color: "gray"
    }
    Row{
        width: parent.width * 0.95
        height: parent.height* 0.7
        anchors.centerIn: parent
        spacing: 1
        Text {
            id:test
            width: parent.width * 0.4
            height:parent.height
            anchors{
                verticalCenter: parent.verticalCenter
            }
            font{
                bold: true
                pixelSize: (height < width) ?
                             height * 0.8 : width * 0.1;
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: "货道号:"

        }

        Custom.MyTextInput{
            id:editor
            width: parent.width * 0.6
            height:parent.height
        }
    }




}

