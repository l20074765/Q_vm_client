import QtQuick 1.1

Rectangle{
    id:col_rect
    width: 768
    height:768
    property string col_id: "1-11"
    property int  col_state: 1
    property int  col_remain: 10
    property string col_goods: "jp0001"

    signal columnClicked()
    border{
        color: "gray"
        width: 1
    }
    color: col_state == 1 ? "blue":
           col_state == 2 ? "red" :
           col_state == 3 ? "yellow": "gray"
    opacity: 0.9
    Column{
        anchors.fill: parent
        spacing: 1
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            text_title:"货道:"
            text_label: col_id
        }
        VMColumnText{
            width: parent.width
            height: parent.height * 0.24
            text_title:"状态:"
            text_label: col_state == 1 ? "正常":
                        col_state == 2 ? "故障":
                        col_state == 3 ? "无货": "禁用"
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
