import QtQuick 1.1

Rectangle{
    width: parent.width
    height: parent.height * 0.08
    property alias text_title: test.text
    property alias text_contex:editor.text
    property alias readOnly: editor.readOnly
    border{
        width: 1
        color: "gray"
    }
    Text {
        id:test
        width: parent.width * 0.2
        height:parent.height
        anchors{
            left: parent.left
            verticalCenter: parent.verticalCenter
        }
        font{
            bold: true
            pixelSize: parent.width * 0.05
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text: "货道号1:"

    }
    Item {
        id: lineEdit
        width: parent.width * 0.8
        height: parent.height
        anchors {
            right: parent.right;
            rightMargin: 5
        }

        BorderImage {
            border{left: 10;top: 10;bottom: 10;right: 10}
            anchors.fill: parent
           // source: "../../../images/tool/lineedit.png"
        }
        TextInput {
            id: editor
            anchors {
                left: parent.left; right: parent.right; leftMargin: 10; rightMargin: 10
                verticalCenter: parent.verticalCenter
            }
            cursorVisible: false;
            color: "#151515"; selectionColor: "Green"
            font{bold: true; pixelSize: 18}
            text: "12"
        }
    }


}

