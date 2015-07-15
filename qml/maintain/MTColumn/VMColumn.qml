import QtQuick 1.1
import Qtvm 1.0


Rectangle{
    id:col_rect
    width: 768
    height:768
    property int  col_bin:1
    property int  col_column:11
    property int  col_state: VmcMainFlow.EV_COLUMN_FAULT
    property int  col_remain: 10
    property int  col_total:10
    property string col_goods: "jp0001"
    property alias colId: col_rect
    signal columnClicked()
    border{
        color: "gray"
        width: 2
    }
    color: col_state == VmcMainFlow.EV_COLUMN_NORMAL ? "#677ae1":
           col_state == VmcMainFlow.EV_COLUMN_FAULT ? "#f65e09" :
           col_state == VmcMainFlow.EV_COLUMN_EMPTY ? "#f3c110": "gray"

    opacity: 0.9
    Column{
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        spacing: 5
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            title_text:"货道:"
            label_font.pixelSize: (width < height) ? width * 0.9 : height * 0.9;
            label_text: col_column
        }
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            title_text:"余量:"
            label_text: col_remain
        }
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            title_text:"商品:"
            label_font.bold: false
            label_font.pixelSize: (width < height) ? width * 0.5 : height * 0.5;
            label_text: col_goods
        }
    }

    MouseArea{
        anchors.fill: parent
        onClicked: {columnClicked();}
    }

 }
