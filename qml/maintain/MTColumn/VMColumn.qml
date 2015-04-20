import QtQuick 1.1
import Qtvm 1.0


Rectangle{
    id:col_rect
    width: 768
    height:768
    property string col_id: "1-11"
    property int  col_bin:1
    property int  col_column:11
    property int  col_state: VmcMainFlow.EV_COLUMN_FAULT
    property int  col_remain: 10
    property int  col_total:10
    property string col_goods: "jp0001"
    signal columnClicked()
    border{
        color: "gray"
        width: 1
    }
    color: col_state == VmcMainFlow.EV_COLUMN_NORMAL ? "blue":
           col_state == VmcMainFlow.EV_COLUMN_FAULT ? "red" :
           col_state == VmcMainFlow.EV_COLUMN_EMPTY ? "yellow": "gray"

    opacity: 0.9
    Column{
        anchors.fill: parent
        anchors.topMargin: 2
        spacing: 5
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            text_title:"货道:"
            text_label: col_id
        }
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            text_title:"余量:"
            text_label: col_remain
        }
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            text_title:"商品:"
            text_label: col_goods
        }
    }

 }
