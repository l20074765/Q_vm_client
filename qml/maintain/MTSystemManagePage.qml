import QtQuick 1.1
import "MTColumn" as MTColumn
Rectangle {
    id:rect_main
    z:5
    // 1.标题栏
    Rectangle{
        id:title
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{top:parent.top ;topMargin: 0}
        border{color: "gray";width: 1}
        MouseArea{anchors.fill: parent} //mask

        Text {
            anchors.centerIn: parent
            verticalAlignment: Text.AlignVCenter
            text: qsTr("系统管理")
            font{
                bold: true
                pixelSize: (parent.height < parent.width) ?
                             parent.height * 0.5: parent.width * 0.1;
            }
        }

    }


    Rectangle{
        id:rect_mainPage
        width: parent.width
        height: parent.height * 0.9
        anchors{top:title.bottom ;topMargin: 0}
    }

    // 1.工具栏
    Rectangle{
        id:rect_tool
        width: parent.width
        height: parent.height * 0.05
        z:5
        anchors{
            bottom: parent.bottom
        }
        smooth: true
        border{ color: "gray";width: 1 }
        MouseArea{anchors.fill: parent} //mask
        MTColumn.MyButton{
            width: parent.width * 0.2
            height: parent.height * 0.75
            anchors.right: parent.right
            anchors.rightMargin: 5
            anchors.verticalCenter: parent.verticalCenter
            text: "返回"
            font{
                bold: true
                pixelSize: (height < width) ? height * 0.6 : width * 0.1;
            }
            onClicked: {
                rect_main.visible = false
            }
        }
    }

}
