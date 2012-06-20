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
                    title: "收 银"
                    style: "ICON_RECT"
                    image: "qrc:/images/dollar_currency_sign.png"
                    backColor: "#4eb3b9"
                    foreColor: "#d54d34"
                    slotQml: "comingsoon.qml"
                },
                ListElement {
                    title: "菜 单"
                    style: "ICON_RECT"
                    image: "qrc:/images/address_book.png"
                    backColor: "#de9317"
                    foreColor: "#d54d34"
                    slotQml: "start.qml"
                },
                ListElement {
                    title: "座 位"
                    style: "ICON_RECT"
                    image: "qrc:/images/map_pin.png"
                    backColor: "#d54d34"
                    foreColor: "#d54d34"
                    slotQml: "SeatView.qml"
                }
            ]
        }
        ListElement {
            segment: 0
            column: [
                ListElement {
                    title: "打 印"
                    style: "ICON_RECT"
                    image: "qrc:/images/print.png"
                    backColor: "#5859b9"
                    foreColor: "#d54d34"
                    slotQml: "PrinterView.qml"
                },
                ListElement {
                    title: "会 员"
                    style: "ICON_RECT"
                    image: "qrc:/images/users.png"
                    backColor: "#96b232"
                    foreColor: "#d54d34"
                    slotQml: "comingsoon.qml"
                },
                ListElement {
                    title: "统 计"
                    style: "ICON_RECT"
                    image: "qrc:/images/chart.png"
                    backColor: "#6e155f"
                    foreColor: "#d54d34"
                    slotQml: "comingsoon.qml"
                }
            ]
        }
        ListElement {
            segment: 0
            column: [
                ListElement {
                    title: "设 置"
                    style: "ICON_RECT"
                    image: "qrc:/images/process.png"
                    backColor: "#034888"
                    foreColor: "#d54d34"
                    slotQml: "comingsoon.qml"
                }
            ]
        }
    }
}
