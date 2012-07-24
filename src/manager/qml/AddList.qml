// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: addList
    width: 400; height:500
    model: addModel
    delegate: addDelegate
    cacheBuffer: 1000
    spacing: 6
    smooth: true
    highlight: Rectangle { id: high; width: 400; color: "#d54d34"; opacity: addList.hightOpacity

    }
    focus: true
    property real hightOpacity: 0.4



    Component {
        id: addDelegate

        Item {
            id: wraper
            width: 400; height: 66
            x: 42
            smooth: true

            Rectangle {
                id: rect
                width: 44
                height: 44
                anchors.left: parent.left
                color: backColor
                anchors.verticalCenter: parent.verticalCenter
                radius: 1
                Image {
                    id: itemImage
                    source: image
                    sourceSize.width: 36
                    sourceSize.height: 36
                    anchors.centerIn: parent
                }
            }

            Text {
                id: nameText
                text: name
                anchors.left: rect.right; anchors.leftMargin: 20
                anchors.top: rect.top
                font.pixelSize: 20
                font.family: "微软雅黑"
                color: "white"
            }

            Text {
                id: detailText
                text: detail
                anchors.left: nameText.left
                anchors.bottom: rect.bottom; anchors.bottomMargin: 1
                font.pixelSize: 14
                font.family: "微软雅黑"
                color: "white"
                opacity: 0.5
            }

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    addList.currentIndex = index
                }

                onPressed: {
                    addList.hightOpacity = 1;
                }
                onReleased: {
                    addList.hightOpacity = 0.4;
                }
                onClicked: {
                    if (name == "菜 单") {
                        editRect.name = name;
                        editRect.backColor = backColor;
                        editRect.image = image;
                        addPanel.state = "new";
                    }
                    else if (name == "购物车") {
                        var index = menuGrid.model.count - 1;
                        var maxcid = -1;
                        if (menuGrid.model.count > 1) {
                            maxcid = menuGrid.model.get(index-1).cid + 1;
                        }
                        else {
                            maxcid = 0;
                        }
                        menuGrid.model.insert(index, {"cid": maxcid, "title": "购物车", "image": "qrc:/images/shopping_cart.png", "style": "ICON_RECT", "slotQml": "qrc:/qml/ItemsView.qml", "backColor": backColor, "foreColor": backColor});
                    }
                    else if (name == "座 位") {
                        var index = menuGrid.model.count - 1;
                        var maxcid = -1;
                        if (menuGrid.model.count > 1) {
                            maxcid = menuGrid.model.get(index-1).cid + 1;
                        }
                        else {
                            maxcid = 0;
                        }
                        menuGrid.model.insert(index, {"cid": maxcid, "title": "座 位", "image": "qrc:/images/map_pin.png", "style": "ICON_RECT", "slotQml": "qrc:/qml/ItemsView.qml", "backColor": backColor, "foreColor": backColor});
                    }
                }
            }
        }
    }

    ListModel {
        id: addModel

        ListElement {
            name: "菜 单"
            image: "qrc:/images/address_book.png"
            backColor: "#4eb3b9"
            detail: "将同类菜品置于该组件中方便用户浏览"
        }

        ListElement {
            name: "购物车"
            image: "qrc:/images/shopping_cart.png"
            backColor: "#96b232"
            detail: "该组建为用户提供全局搜素功能"
        }

        ListElement {
            name: "座 位"
            image: "qrc:/images/map_pin.png"
            backColor: "#FF0097"
            detail: "用户可以添加自己喜欢的菜式到该组件"
        }
    }
}
