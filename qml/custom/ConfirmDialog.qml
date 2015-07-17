import QtQuick 1.1
import "../maintain/MTColumn" as  MTColumn


Rectangle {
    id:root
    width: 100
    height: 62
    z:3

    property alias text: textStr.text

    signal accept()
    signal reject()
    opacity: 0.9
    color: "gray"
    MouseArea{
        anchors.fill: parent
    }

    Rectangle{
        z:5
        width: parent.width * 0.6
        height: parent.height * 0.2
        anchors.centerIn: parent
        //color: "#252528"
        opacity: 0.8
        radius: 8

        gradient: Gradient {
            GradientStop { position: 0.0; color: "#57575f" }
            //GradientStop { position: 0.3; color: "#252528" }
            GradientStop { position: 0.5; color: "#252528" }
            //GradientStop { position: 0.7; color: "#252528" }
            GradientStop { position: 1.0; color: "#57575f" }
        }

        border{
            width: 5;color: "#c8c8ce"
        }



        Text{
            id:textStr
            width: parent.width
            height: parent.height * 0.5
            anchors.top:parent.top
            anchors.topMargin: (width < height) ?width * 0.25 : height * 0.25
            smooth: true
           // readOnly: true
            text:"内容提示区"
            color: "white"
            elide: Text.ElideLeft
            font.bold: false
            font.pixelSize: (width < height) ? width * 0.25: height * 0.25;
            horizontalAlignment: Text.AlignHCenter
        }

        Row{
            width: parent.width * 0.8
            height: parent.height * 0.25
            anchors.bottom: parent.bottom
            anchors.bottomMargin: (width < height) ?width * 0.25 : height * 0.25
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: width * 0.2
            MTColumn.MyButton{
                width: parent.width * 0.4
                height: parent.height * 0.8
                font.bold: true
                font.pixelSize: (width < height) ? width * 0.6: height * 0.6;
                //color: "#57575f"
                text_color:pressed ? "white" : "#252528";
                text: "确定"
                onClicked: {
                   accept();
                   root.destroy();
                }
            }
            MTColumn.MyButton{
                width: parent.width * 0.4
                height: parent.height * 0.8
                font.bold: true
                font.pixelSize: (width < height) ? width * 0.6: height * 0.6;
                text: "取消"
                //color: "#57575f"
                text_color:pressed ? "white" : "#252528";
                onClicked: {
                    reject();
                    root.destroy();
                }
            }
        }

    }


}

