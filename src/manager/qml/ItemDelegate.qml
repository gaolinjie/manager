// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component {
    id: itemDelegate
    Item {
        id: wraper
        width: grid.cellWidth; height: grid.cellHeight

        Component.onCompleted: {
            var component;
            if (style == "IMAGE_RECT") {
                component = Qt.createComponent("ItemRect.qml");
                component.createObject(wraper);
                console.log("fff")

            }
            else {
                component = Qt.createComponent("AddRect.qml");
                component.createObject(wraper);
            }
        }
    }
}
