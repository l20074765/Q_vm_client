import QtQuick 1.1

//状态栏
Rectangle{
    id:status_rect
    signal status_back_clicked

    width: 100
    height: 50
    Image {
        id: status_image
        width: parent.width
        height: parent.height
        anchors.fill: parent
        smooth: true
        source: "../../images/tool/status.png"
        rotation: 0


    }
    Text{
        width: parent.width * 0.2
        height: parent.height * 0.8
        anchors{
            verticalCenter: parent.verticalCenter
            left:parent.left
            leftMargin: 5
        }
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        smooth: true
        font.bold: true
        font.pixelSize:(width < height) ? width * 0.7 : height * 0.7
        color: "#FFFFFF"
        text:"首页"
    }

    Text{
        width: parent.width * 0.15
        height: parent.height
        anchors{
            verticalCenter: parent.verticalCenter
            right: parent.right
            rightMargin: 10
        }
        smooth: true
        color: "#FFFFFF"
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        font.bold: true
        font.pixelSize:(width < height) ? width * 0.6 : height * 0.6
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

