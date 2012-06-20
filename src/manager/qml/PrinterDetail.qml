// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    width: 300
    height: 600

    Text {
        id: choosePrinterTitle
        anchors.left: parent.left
        anchors.top: parent.top
        text: "选择网络中的打印机"
        font.pixelSize: 20
        color: "black"
    }

    Rectangle {
        id: choosePrinterRect
        width: 320; height: 36
        color: "#BABAB9"
        border.color: "#A3A5A0"//"#d54d34"
        border.width: 2
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTitle.bottom; anchors.topMargin: 15
    }

    Text {
        id: chooseCategoryTitle
        anchors.left: choosePrinterRect.left
        anchors.top: choosePrinterRect.bottom; anchors.topMargin: 40
        text: "指定发送到该打印机的菜品类别"
        font.pixelSize: 20
        color: "black"
    }

    Tag {
        id: tag
        name: "特色"
        anchors.left: chooseCategoryTitle.left
        anchors.top: chooseCategoryTitle.bottom; anchors.topMargin: 20
    }

    Tag {
        id: tag2
        name: "炒菜"
        anchors.left: tag.right; anchors.leftMargin: 4
        anchors.top: tag.top
    }

    Image {
        id: addTag
        source: "qrc:/images/tag_add.png"
        anchors.left: tag2.right; anchors.leftMargin: 4
        anchors.top: tag.top
    }

    Text {
        id: chooseItemTitle
        anchors.left: chooseCategoryTitle.left
        anchors.top: chooseCategoryTitle.bottom; anchors.topMargin: 160
        text: "指定发送到该打印机的菜品"
        font.pixelSize: 20
        color: "black"
    }
}
