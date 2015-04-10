import QtQuick 1.1

Rectangle{
    id:mtBar
    signal button_clicked()
    property string button_text: "维护按钮"
    property real border_width: 2
    property alias pressed: mymouse.pressed
    color: pressed ? "white" :"gray"
    opacity: 0.9
    width: 100
    height: 80
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
        color: parent.pressed? "gray" :"white"
    }

    MouseArea{
        id:mymouse
        anchors.fill: parent
        onEntered: {
            console.log(qsTr("维护按钮进入"))
        }
        onClicked: {
            console.log(qsTr("维护按钮点击"))
            button_clicked()
        }
    }
}

