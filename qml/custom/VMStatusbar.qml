import QtQuick 1.1

//状态栏
Rectangle{
    id:status_rect
    property alias back: back_text.text
    property alias function1Test: function1_test.text
    signal status_back_clicked
    signal function1_clicked();
    width: 100
    height: 50
    MouseArea{anchors.fill: parent} //mask
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
        id:function1_test
        width: parent.width * 0.3
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
        font.pixelSize:(width < height) ? width * 0.45 : height * 0.45
        color: "#FFFFFF"
        text:""
        MouseArea{
            anchors.fill: parent
            onClicked: {
                function1_clicked()
            }
        }
    }


    Rectangle{

    }

    Text{
        id:back_text
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

