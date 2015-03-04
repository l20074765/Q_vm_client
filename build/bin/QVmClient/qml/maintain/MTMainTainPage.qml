import QtQuick 1.1


Rectangle{
    id:mtMainTainPage
    property string datatime: "2015-01-02 12:12:12"
    width: 100
    height: 200
    visible: false
    Text {
        id: sys_text
        anchors{
            top:parent.top
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }
        horizontalAlignment: Text.horizontalAlignment
        text: qsTr("系统维护")
        font{
            bold: true
            pixelSize: 20
        }
    }

    Text {
        id: sys_time_text
        anchors{
            top:sys_text.bottom
            topMargin: 5
            horizontalCenter: parent.horizontalCenter
        }

        horizontalAlignment: Text.AlignHCenter
        font{
            bold: true
            pixelSize: 16
        }
        text: qsTr("系统时间:") + mtMainTainPage.datatime
    }
    Timer {
        interval: 500; running: true; repeat: true;
        onTriggered: {
            mtMainTainPage.datatime = Qt.formatDateTime(new Date(),"yyyy-MM-dd HH:mm:ss")
        }
    }
}

