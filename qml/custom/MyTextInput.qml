import QtQuick 1.1

Rectangle{
    property alias text: editor.text
    property alias readOnly: editor.readOnly
    property int margin: 2
    width: 100
    height: 40
    smooth: true
    radius: 5
    border{
        width: editor.activeFocus ? margin: margin / 2;
        color: editor.activeFocus ? "green": "gray";
    }

    TextInput {
        id: editor
        width: parent.width - margin * 2
        height: parent.height - margin * 2
        anchors.centerIn: parent
        activeFocusOnPress: true
        cursorVisible: false;
        color: "#151515"; selectionColor: "Green"
        font{
            bold: true;
            pixelSize: (parent.height < parent.width) ?
                         parent.height * 0.8 : parent.width * 0.1;
        }
        text: "12"
        onActiveFocusChanged: {
            console.log("编辑框进入:" + editor.activeFocus);
        }
    }
}

