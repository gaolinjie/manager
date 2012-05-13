// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 400
    height: 800

    Rectangle {
        id: panel
        width: parent.width
        height: parent.height
        color: "#de9317"
        z: 2

        Text {
            id: title
            x: 40; y: 40
            text: "新 建"
            font.pixelSize: 38
            color: "white"
        }

        AddList {
            id: addList
            anchors.top: title.bottom
            anchors.topMargin: 30
            visible: false
            x: 400
        }

        Item {
            id: editRect
            width: 400
            height:700
            anchors.top: addList.top

            Rectangle {
                id: rect
                width: 44
                height: 44
                //anchors.left: parent.left
                x: 42
                color: "#96b232"
                //anchors.verticalCenter: parent.verticalCenter
                radius: 1
                Image {
                    id: itemImage
                    source: "qrc:/images/search.png"
                    sourceSize.width: 42
                    sourceSize.height: 42
                    anchors.centerIn: parent
                }
            }

            Text {
                id: nameText
                text: "搜 索"
                anchors.left: rect.right; anchors.leftMargin: 20
                anchors.top: rect.top
                font.pixelSize: 20
                color: "white"
            }

            Text {
                id: nameTitle
                text: "菜单名称:"
                anchors.left: rect.left
                anchors.top: rect.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            Rectangle {
                id: nameEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: rect.left
                anchors.top: nameTitle.bottom; anchors.topMargin: 15
                clip: true


                TextEdit {
                    width: 300
                    text: ""
                    font.pixelSize: 20
                    color: "white"
                    focus: true
                    anchors.centerIn: parent
                    clip: true
                }
            }

            Text {
                id: backTitle
                text: "背景颜色:"
                anchors.left: rect.left
                anchors.top: nameEdit.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            Rectangle {
                id: backEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: rect.left
                anchors.top: backTitle.bottom; anchors.topMargin: 15
                clip: true
            }

            Text {
                id: foreTitle
                text: "前景颜色:"
                anchors.left: rect.left
                anchors.top: backEdit.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            Rectangle {
                id: foreEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: rect.left
                anchors.top: foreTitle.bottom; anchors.topMargin: 15
                clip: true
            }

            ColorPicker {
                id: colorPicker
                anchors.top: foreEdit.bottom; anchors.topMargin: 9
                anchors.left: rect.left
            }



        }
    }

    BorderImage {
        anchors.fill: panel
        anchors { leftMargin: -9; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:/images/shadow.png";
        smooth: true
        z: 1
    }
}
