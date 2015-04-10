import QtQuick 1.1
import "MTColumn" as MTColumn
Rectangle {
    id:rect_main
    z:5
    // 1.标题栏
    Rectangle{
        id:rect_title
        width: parent.width
        height: parent.height * 0.05
        anchors{top:parent.top ;topMargin: 0}
        border{color: "gray";width: 1}
        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("交易管理")
            font{
                bold: true
                pixelSize: 20
            }
        }
    }
    Rectangle{
        id:rect_mainPage
        width: parent.width
        height: parent.height * 0.9
        anchors{top:rect_title.bottom ;topMargin: 0}
    }

    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        anchors.top:rect_mainPage.bottom
        MTColumn.MyButton{
            anchors.right: parent.right
            anchors.rightMargin: 10
            width: parent.width * 0.2
            height: parent.height * 0.8

            text: "返回"
            onClicked: {
                rect_main.visible = false
            }
        }

    }


}
