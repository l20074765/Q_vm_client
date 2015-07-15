import QtQuick 1.1
import "../../custom" as Custom

Rectangle{
    id:rect_columnInput
    width: 100
    height: 40
    property alias text_title: test.text
    property alias text_contex:editor.text
    property alias readOnly: editor.readOnly
    property alias validator: editor.validator
    property alias activeFocus: editor.activeFocus
    property alias tipText: tip.text
    signal displayTextChanged()
    signal activeFocused();
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
            width: parent.width * 0.3
            height:parent.height
            anchors{
                verticalCenter: parent.verticalCenter
            }
            font{
                bold: true
                pixelSize: (height < width) ? height * 0.8 : width * 0.1;
            }
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            text: "货道号:"

        }
        Text{
            id:tip
            width: parent.width * 0.1
            height: parent.height
            anchors.verticalCenter: parent.verticalCenter
            font.bold: false
            font.pixelSize: (height < width) ?
                                height * 0.5 : width * 0.06;
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            color: "red"
            text:""
        }

        Custom.MyTextInput{
            id:editor
            width: parent.width * 0.6
            height:parent.height
            onDisplayTextChanegd: {
              //  console.log("编辑框内容更改。。。。");
                rect_columnInput.displayTextChanged();
            }
            onActiveFocused: {
                rect_columnInput.activeFocused();
            }
        }
    }




}

