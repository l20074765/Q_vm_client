import QtQuick 1.1
import Qtvm 1.0

Rectangle {
    id:ads_page
    width: 350
    height: 450
    anchors.fill: parent
    signal ads_clicked  //广告页面点击信号
    property int adsIndex: 0
    property string ads_path_str: "../../images/ads/"
    property string ads_pic_str: "5.jpg"
    property string ads_file_str: "test"

    onVisibleChanged: {
        console.log("广告页面显示更改" + visible);
        if(visible == true){
            ads_turn();
        }
    }

    //广告图片
    Image {
        id: ads_image
        source: ads_path_str + ads_pic_str
        width: parent.width
        height:parent.height*0.85
        anchors{top:parent.top}
        fillMode: Image.PreserveAspectCrop
        clip: true //开启裁剪图像
    }
    //广告视频
    VMVideo{
        id:vm_video
        width: parent.width
        height: parent.height*0.85
        anchors.fill: parent
        onVideo_finished:{
            console.log(qsTr("视频播放完毕"));
            ads_turn();
        }

    }

    //广告栏
    Image{
        id:ads_bar
        source: "../../images/tool/bar-inservice.png"
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
            ads_timer.stop();
            if(ads_file_str.indexOf("avi") > 0){
                 vm_video.stop();
            }
        }

    }


    //定时切图
    Timer{
        id:ads_timer
        interval: 100; running: true; repeat: true;
        onTriggered: {
            ads_timer.interval = 8000;
            ads_turn();
        }
    }

    function ads_turn(){
        var fileList = vm.adsFileList;
        var count = fileList.length;
        if(count){
            if(adsIndex > (count - 1))
                adsIndex = 0;
            ads_file_str = fileList[adsIndex];
            if(ads_file_str.indexOf("avi") > 0)//判断是视频
            {
                console.log(qsTr("是为视频:") + ads_file_str);
                vm_video.play(ads_path_str + ads_file_str);
                vm_video.visible = true;
                ads_image.visible = false;
                ads_timer.stop();

            }
            else{
                console.log(qsTr("是为图片:") + ads_pic_str);
                vm_video.visible = false;
                ads_image.visible = true;
                ads_pic_str =  ads_file_str;
                if(ads_timer.running == false)
                    ads_timer.start();
            }
            if(adsIndex < (count - 1)){
                adsIndex++;
            }
            else{
                adsIndex = 0;
            }


        }
    }

}

