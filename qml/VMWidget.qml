import QtQuick 1.1

Rectangle {
    id:widget
    width:100
    height:200
    color:"white"
    state:"hide"
    states:
    [
        State
        {
            name:"show"
            PropertyChanges
            {
                target: widget
                visible:true
                opacity:1
            }


        },
        State
        {
            name:"hide"
            PropertyChanges
            {
                target: widget
                visible:false
                opacity:0
            }
        }

    ]

    transitions:
    [
        Transition
        {
            PropertyAnimation
            {
                property:"opacity"
                duration: 500
            }
        }
    ]
}
