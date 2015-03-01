import QtQuick 1.1

Rectangle{
    id:mtBar
    signal button_clicked()
    property string button_text: qsTr("维护按钮")
    property real border_width: 2

    color: "white"
    width: 100
    height: 200
    border{
        width: border_width
        color: "gray"
    }
    Text {
        text: button_text
        anchors.fill: parent
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font{
            bold:true
            pixelSize: 18
        }
    }

    MouseArea{
        anchors.fill: parent

        onEntered: {
            console.log(qsTr("鼠标进入"))
            mtBar.color ="black"
            mtBar.opacity = 0.5
        }



        onClicked: {
            console.log(qsTr("鼠标点击"))
            button_clicked()
            mtBar.color = "white"
            mtBar.opacity = 1
        }
    }
}

