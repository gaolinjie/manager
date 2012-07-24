// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: pinterDetail
    width: 300
    height: 600
    x: 100

    Component.onCompleted: {
        pinterDetail.x = 0;
    }

    Behavior on x {
        NumberAnimation { duration: 500; easing.type: Easing.OutQuint}
    }

    Text {
        id: printerDetailTitle
        anchors.left: parent.left
        anchors.top: parent.top
        text: "打印机配置详情"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 30
        color: "black"
    }

    Text {
        id: choosePrinterTitle
        anchors.left: printerDetailTitle.left
        anchors.top: printerDetailTitle.bottom; anchors.topMargin: 30
        text: "选择网络中的打印机"
        font.family: "微软雅黑"
            smooth: true
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
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "black"
    }

    Text {
        id: chooseItemTitle
        anchors.left: chooseCategoryTitle.left
        anchors.top: chooseCategoryTitle.bottom; anchors.topMargin: 160
        text: "指定发送到该打印机的菜品"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "black"
    }

    CategoryTagGrid {
        id: categoryTagGrid
        anchors.left: chooseCategoryTitle.left
        anchors.top: chooseCategoryTitle.bottom; anchors.topMargin: 20
    }  
}
