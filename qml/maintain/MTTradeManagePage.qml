import QtQuick 1.1

Rectangle {
    id:mtTrade
    width: 100
    height: 62
    visible: false
    Component{
        id:mtTrade_delegate
        Rectangle{
            width: mtTrade.width
            height: mtTrade.height * 0.06
            border{
                color: "gray"
                width: 2
            }


            Text {
                anchors.centerIn: parent
                text: mt_title
                font{
                    bold: true
                    pixelSize: 20
                }
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }

            MouseArea{
                anchors.fill: parent
                onClicked: {
                    console.log("点击");
                }
            }

        }
    }



    ListModel{
        id:mtTrade_model
        ListElement{
            mt_title:"商品管理"
        }
        ListElement{
            mt_title:"货道管理"
        }
        ListElement{
            mt_title:"交易数据"
        }
        ListElement{
            mt_title:"销售报表"
        }
    }
    ListView{
        id:mtTrade_listView
        anchors.fill: parent
        spacing: 5
        delegate: mtTrade_delegate
        model: mtTrade_model
        flickableDirection:Flickable.VerticalFlick


    }

}

