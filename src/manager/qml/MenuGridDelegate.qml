// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Component {
    id: startDelegate
    Item {
        id: wraper
        width: grid.cellWidth; height: grid.cellHeight

        Component.onCompleted: {
            var component;
            if (style == "IMAGE_RECT") {
                component = Qt.createComponent("ImageRect.qml");
                component.createObject(wraper);

            }
            else if (style == "ICON_RECT") {
                component = Qt.createComponent("IconRect2.qml");
                component.createObject(wraper);
            }
            else {
                component = Qt.createComponent("AddRect.qml");
                component.createObject(wraper);
            }
        }
    }
}
