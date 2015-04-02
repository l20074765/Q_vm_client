var itemComponent = null;
var posnInWindow;
var parentWIndow;

function loadComponent(parent) {
    parentWIndow = parent;
    console.log("loadComponent  " +  "parent="  + parentWIndow)
    var itemColumn = null;
    //组件为空需要先创建组件
    if(itemComponent == null){
        itemComponent = Qt.createComponent("VMColumnEdit.qml");
        if (itemComponent.status == Component.Loading)  //Depending on the content, it can be ready or error immediately
            component.statusChanged.connect(createItem);
        else
            createItem();
    }
    else
        createItem();

    return itemColumn;
}


function createItem() {
    var itemColumn = null;
    if (itemComponent.status == Component.Ready ) {
        console.log("ComponentReady:" + parentWIndow)

        itemColumn = itemComponent.createObject(parentWIndow, {"x": 0 ,"y":0 , "z": 3});
        var pos = itemColumn.mapToItem(parentWIndow,0,0);
/*
        itemColumn.width = parentWIndow.width  * 0.8;
        itemColumn.height = parentWIndow.height * 0.8;
        itemColumn.x = parentWIndow.x + (parentWIndow.width - itemColumn.width) /2;
        itemColumn.y = parentWIndow.y + (parentWIndow.height - itemColumn.height) /2 ;
*/
        console.log("创建对象" + parentWIndow + " "+itemColumn)
        itemColumn.anchors.fill = parentWIndow
        itemColumn.parent = parentWIndow
        // make sure created item is above the ground layer
    } else if (itemComponent.status == Component.Error) {
        console.log("error creating component");
        console.log(itemComponent.errorString());
    }

    return itemColumn;
}


function destroyItem(obj)
{
    console.log("销毁对象" + obj)
    if (obj != null){
        obj.destroy();
        obj = null;
    }
}


