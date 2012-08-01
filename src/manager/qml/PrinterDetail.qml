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
        color: "white"
    }

    Text {
        id: choosePrinterTitle
        anchors.left: printerDetailTitle.left
        anchors.top: printerDetailTitle.bottom; anchors.topMargin: 30
        text: "网络中的打印机"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "white"
    }
/*
    Rectangle {
        id: choosePrinterRect
        width: 320; height: 36
        color: "#BABAB9"
        border.color: "#A3A5A0"//"#d54d34"
        border.width: 2
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTitle.bottom; anchors.topMargin: 15
    }  */

    ComboBox {
        id: selectPrinterDeviceComboBox
        prompt: "请选择网络中的打印机设备"
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTitle.bottom; anchors.topMargin: 15
        dropDown: true
        z: 3
        contentModel: printerDeviceModel
        onOperate: {
        }
        ListModel {
            id: printerDeviceModel
            ListElement {
                name: "GP-100125"
            }
            ListElement {
                name: "EPSON-6000"
            }
            ListElement {
                name: "STAR-2578"
            }
        }
    }

    Text {
        id: choosePrinterTypeTitle
        anchors.left: printerDetailTitle.left
        anchors.top: selectPrinterDeviceComboBox.bottom; anchors.topMargin: 30
        text: "打印机类型"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "white"
    }

    ComboBox {
        id: selectPrinterTypeComboBox
        prompt: "请选择打印机类型"
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTypeTitle.bottom; anchors.topMargin: 15
        dropDown: true
        z: 2
        contentModel: printerTypeModel
        onOperate: {
        }

        ListModel {
            id: printerTypeModel
            ListElement {
                name: "前台打印机"
            }
            ListElement {
                name: "厨房打印机"
            }
            ListElement {
                name: "其它类型"
            }
        }
    }
}
