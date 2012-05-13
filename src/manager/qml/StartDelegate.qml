import QtQuick 1.0

Component {
    id: startDelegate

    Item {
        width: 300; height: 465
        Column {
            id: col
            spacing: 6

            Repeater {
                model: column

                Item {
                    id: wraper
                    width: 300; height: 150

                    Component.onCompleted: {
                        var component;
                        if (style == "IMAGE_RECT") {
                            component = Qt.createComponent("ImageRect.qml");
                            component.createObject(wraper, {"iconSource": image, "iconTitle": title});

                        }
                        else if (style == "ICON_RECT") {
                            component = Qt.createComponent("IconRect.qml");
                            component.createObject(wraper, {"iconSource": image, "iconTitle": title});
                        }
                        else {
                            component = Qt.createComponent("AddRect.qml");
                            component.createObject(wraper);
                        }
                    }
                }
            }
        }
    }
}
