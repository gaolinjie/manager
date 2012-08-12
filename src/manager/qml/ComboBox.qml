// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: comboBox
    width: 320; height: 36
    color: "#de9317"
    border.color: "white"
    border.width: 2
    //clip: true

    property string prompt: ""
    property bool dropDown: true
    property ListModel contentModel: dropListModel

    signal operate(int index)

    Component.onCompleted: {
    }

    MouseArea {
        id: mouse
        anchors.fill: parent
        onClicked: {
            if (dropRect.visible) {
                dropRect.visible = false
                dropIcon.text = comboBox.dropDown ? "∨" : "∧"
            }
            else {
                dropRect.visible = true
                dropIcon.text = comboBox.dropDown ? "∧" : "∨"
            }
        }
    }

    Text {
        id: promptTitle
        text: comboBox.prompt
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 16
        font.family: "微软雅黑"
        smooth: true
        color: "white"
    }

    Text {
        id: dropIcon
        text: comboBox.dropDown ? "∨" : "∧"
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 24
        font.family: "微软雅黑"
        font.bold: true
        smooth: true
        color: "white"

        states: [
            State {
                name: "down"
                PropertyChanges { target: dropIcon; text: "∨" }
                when: comboBox.dropDown
            },

            State {
                name: "up"
                PropertyChanges { target: dropIcon; text: "∧" }
                when: comboBox.dropDown
            }
        ]
    }

    Rectangle {
        id: dropRect
        width: parent.width
        height: dropList.height+40
        color: comboBox.color//"#343434"//
        border.color: "white"
        border.width: 2
        clip: true
        visible: false
        y: comboBox.dropDown ? comboBox.height + 4 : -dropRect.height - 4

        ListView {
            id: dropList
            width: parent.width-20; height: dropList.count*20
            anchors.centerIn: parent
            model: comboBox.contentModel//dropListModel
            delegate: dropListDelegate
            cacheBuffer: 1000
            //spacing: 2
            smooth: true
            highlight: Rectangle { id: high; width: dropList.width; color: "#d54d34"; opacity: dropList.hightOpacity

            }
            focus: true
            property real hightOpacity: 0.4

            Component {
                id: dropListDelegate
                Rectangle {
                    id: rect
                    color: comboBox.color
                    radius: 1
                    width: dropList.width-10; height: 20
                    x: 10
                    smooth: true

                    Text {
                        id: nameText
                        text: name
                        x: 10
                        anchors.verticalCenter: parent.verticalCenter
                        font.pixelSize: 15
                        font.family: "微软雅黑"
                        color: "white"
                        smooth: true
                    }

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            dropList.currentIndex = index
                        }
                        onPressed: {
                            dropList.hightOpacity = 1;
                        }
                        onReleased: {
                            dropList.hightOpacity = 0.4;
                        }
                        onClicked: {
                            operate(index)
                            if (dropRect.visible) {
                                dropRect.visible = false
                                dropIcon.text = comboBox.dropDown ? "∨" : "∧"
                            }
                            else {
                                dropRect.visible = true
                                dropIcon.text = comboBox.dropDown ? "∧" : "∨"
                            }
                            comboBox.prompt = dropList.model.get(index).name;
                        }
                    }
                }
            }
/*
            ListModel {
                id: dropListModel

                ListElement {
                    name: "炒菜厨房打印机1"
                }

                ListElement {
                    name: "炒菜厨房打印机2"
                }

                ListElement {
                    name: "炒菜厨房打印机3"
                }
                ListElement {
                    name: "凉菜厨房打印机"
                }

                ListElement {
                    name: "汤煲厨房打印机"
                }

                ListElement {
                    name: "酒水打印机"
                }
            }*/
        }
    }
}
