import QtQuick 1.1

Rectangle {
    id:widget
    width:100
    height:200
    property real titleHR: 0.05
    property real statusHR: 0.05
    property real rectHR: 0.9
    color:"white"
    visible: false
    property int duration: 500


    function show(){
        visible = true;
        //opacity = 1;
        animShow.start();
    }

    function hide(){
        animHide.start();
    }

    function close(){
        visible = false;
    }



    //------------------------------
    // 动画
    //------------------------------
    PropertyAnimation {
        id: animShow
        target: widget
        duration: widget.duration
        easing.type:  Easing.Linear
        property: 'opacity';
        from: 0;
        to: 1
    }
    PropertyAnimation {
        id: animHide
        target: widget
        duration: widget.duration
        easing.type: Easing.Linear
        property: 'opacity';
        from: 1;
        to: 0
        onCompleted: {
            close()
        }
    }
}
