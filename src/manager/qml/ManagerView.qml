// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

import QtQuick 1.0

ListView {
    id: managerView
    width: 1000; height:500
    model: managerModel
    delegate: managerDelegate
    orientation: ListView.Horizontal
    cacheBuffer: 1000
    spacing: 6
    smooth: true
    section.property: "segment"
    section.criteria: ViewSection.FullString
    section.delegate: space

    Component {
        id: space
        Item {
            width: 60
            height: 10
        }
    }

    Component {
        id: managerDelegate

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
                            else {
                                component = Qt.createComponent("IconRect.qml");
                                component.createObject(wraper, {"iconSource": image, "iconTitle": title});
                            }
                        }
                    }
                }
            }
        }
    }

    ListModel {
        id: managerModel

        ListElement {
            segment: 0
            column: [
                ListElement {
                    title: "菜 单"
                    style: "ICON_RECT"
                    image: "qrc:/images/note.png"
                    rectColor: "#4eb3b9"
                    hotColor: "#d54d34"
                    slotQml: "start.qml"
                }
            ]
        }
    }
}
