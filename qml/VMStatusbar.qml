import QtQuick 1.1

//状态栏
Rectangle{
    id:status_rect
    signal status_back_clicked

    width: parent.width
    height: parent.height*0.05
    Image {
        id: status_image
        width: parent.width
        height: parent.height
        anchors.fill: parent
        source: "../images/tool/topbg.png"
        rotation: 0


    }
    Text{
        width: 50
        height: 20
        anchors{
            verticalCenter: parent.verticalCenter
            left:parent.left
            leftMargin: 5
        }
        font.bold: true
        font.pixelSize: parent.height * 0.5
        color: "#FFFFFF"
        text:"首页"
    }

    Text{
        width: 50
        height: 20
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 5
        }
        color: "#FFFFFF"
        font.bold: true
        font.pixelSize: parent.height * 0.5
        text:"退出"
        MouseArea{
            anchors.fill: parent
            onClicked: {
                status_back_clicked()
                console.log(qsTr("返回按钮触发"))
            }
        }
    }


}

