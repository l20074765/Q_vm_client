import QtQuick 1.1

Rectangle {
    id:ads_page
    width: 350
    height: 450
    anchors.fill: parent
    signal ads_clicked  //广告页面点击信号

    //广告图片
    Image {
        id: ads_image
        source: "../images/ads/5.jpg"
        width: parent.width
        height:parent.height*0.85
        anchors{top:parent.top}
        fillMode: Image.PreserveAspectCrop
        clip: true //开启裁剪图像
    }
    //广告栏
    Image{
        id:ads_bar
        source: "../images/ads/bar-inservice.png"
        width: parent.width
        height:parent.height*0.15
        anchors{top:ads_image.bottom}
        fillMode: Image.PreserveAspectCrop
        clip: true //开启裁剪图像
    }
    //鼠标点击事件
    MouseArea{
        id:ads_mouse
        width: parent.width
        height:parent.height
        onClicked:{
            console.log("main:onClicked....")
            ads_clicked()
        }

    }

}

