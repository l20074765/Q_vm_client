var parentWIndow;
var itemColumn;
var itemComponent;

function loadComponent(parent,qml) {
    parentWIndow = parent;
    console.log("准备创建组件:" + "parent="  + parentWIndow +
                " qml:" + qml);
    itemComponent = Qt.createComponent(qml);
    if (itemComponent.status == Component.Loading)
        component.statusChanged.connect(createItem);
    else
        createItem();
    return itemColumn;
}


function createItem() {
    if (itemComponent.status == Component.Ready ) {
        itemColumn = itemComponent.createObject(parentWIndow, {"x": 0 ,"y":0 , "z": parentWIndow.z + 1});
        console.log("创建对象" + itemColumn)
        itemColumn.width = parentWIndow.width
        itemColumn.height = parentWIndow.height
        itemColumn.anchors.fill = parentWIndow
        itemColumn.parent = parentWIndow
    } else if (itemComponent.status == Component.Error) {
        console.log("组件创建失败");
        console.log(itemComponent.errorString());
    }
}


function destroyItem(obj)
{
    console.log("销毁对象" + obj)
    if (obj != null){
        obj.destroy();
        obj = null;
    }
}


