import QtQuick 1.1

Rectangle{
    id:mtBar
    signal button_clicked()
    property string button_text: "维护按钮"
    property alias pressed: mymouse.pressed
    color: pressed ? "white" :"gray"
    opacity: 1
    width: 100
    height: 80
    border{
        width: 2
        color: "gray"
    }

    //smooth: true
    Text {
        text: button_text
        anchors.centerIn: parent
        font{
            bold:true
            pixelSize: (parent.height < parent.width) ?
                           parent.height * 0.2 : parent.width * 0.2
        }
        color: parent.pressed ? "gray" :"white"
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

