import QtQuick 1.1

Rectangle {
    width: 100
    height: 62
    //color: "#00000000"
    smooth: true
    //color: "trans"
    opacity: 0.8
    AnimatedImage {
        id: name
        anchors.centerIn: parent
        opacity: 0.8
        source: "../../images/tool/loading1.gif"
        fillMode: Image.PreserveAspectFit

    }
}

