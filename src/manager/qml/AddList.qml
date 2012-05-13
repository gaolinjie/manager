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
                color: rectColor
                anchors.verticalCenter: parent.verticalCenter
                radius: 1
                Image {
                    id: itemImage
                    source: image
                    sourceSize.width: 42
                    sourceSize.height: 42
                    anchors.centerIn: parent
                }
            }

            Text {
                id: nameText
                text: name
                anchors.left: rect.right; anchors.leftMargin: 20
                anchors.top: rect.top
                font.pixelSize: 20
                color: "white"
            }

            Text {
                id: detailText
                text: detail
                anchors.left: nameText.left
                anchors.bottom: rect.bottom; anchors.bottomMargin: 1
                font.pixelSize: 14
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


            }
        }
    }

    ListModel {
        id: addModel

        ListElement {
            name: "菜 单"
            image: "qrc:/images/POI.png"
            rectColor: "#d54d34"
            detail: "将同类菜品置于该组件中方便用户浏览"
        }

        ListElement {
            name: "搜 索"
            image: "qrc:/images/search.png"
            rectColor: "#96b232"
            detail: "该组建为用户提供全局搜素功能"
        }

        ListElement {
            name: "喜 欢"
            image: "qrc:/images/favs.png"
            rectColor: "#FF0097"
            detail: "用户可以添加自己喜欢的菜式到该组件"
        }
    }
}
