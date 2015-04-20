var itemComponent = null;
var parentWIndow;
var itemColumn;


function loadComponent(parent) {
    parentWIndow = parent;
    console.log("loadComponent  " +  "parent="  + parentWIndow)
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

    if (itemComponent.status == Component.Ready ) {
        console.log("ComponentReady:" + parentWIndow)

        itemColumn = itemComponent.createObject(parentWIndow, {"x": 0 ,"y":0 , "z": 9});
        console.log("创建对象" + parentWIndow + " "+itemColumn)
        itemColumn.anchors.fill = parentWIndow
        itemColumn.parent = parentWIndow
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









