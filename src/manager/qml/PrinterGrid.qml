import QtQuick 1.0
import "../js/global.js" as Global

GridView {
    id: printerGrid
    model: PrinterModel{}
    delegate: printerDelegate
    cacheBuffer: 100
    cellWidth: 350
    cellHeight: 85
    width: 1000
    height: 470
    flow: GridView.TopToBottom
    interactive: false

    Component {
        id: printerDelegate

        Item {
             width: 320; height: 60

             Rectangle {
                 id: nameRect
                 width: 320 - parent.height; height: 60
                 color: active == 1 ? "#7B3349" : "#A3A5A0"

                 Text {
                     id: nameText
                     text: name
                     anchors.left: parent.left; anchors.leftMargin: 30
                     anchors.top: parent.top; anchors.topMargin: 10
                     color: active == 1 ? "white" : "black"
                     font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 18
                 }

                 Text {
                     id: addText
                     text: "点击右边按钮添加打印机"
                     anchors.left: parent.left; anchors.leftMargin: 30
                     anchors.verticalCenter: parent.verticalCenter
                     color: active == 1 ? "white" : "black"
                     font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 18
                     visible: addButton.visible
                 }

                 MouseArea {
                     anchors.fill: parent
                     onClicked: {
                         if (addText.visible) {
                         }
                         else {
                             for (var i = 0; i < printerGrid.model.count; i++) {
                                 if (printerGrid.model.get(i).pid == pid) {
                                     printerGrid.model.setProperty(i, "active", 1);
                                 }
                                 else {
                                     printerGrid.model.setProperty(i, "active", 0);
                                 }
                             }
                         }
                     }
                 }
             }

             Rectangle {
                 id: delButtonRect
                 width: parent.height; height: parent.height
                 color: "#DE4209"
                 anchors.right: parent.right

                 Image {
                     id: delButton
                     source: "qrc:/images/minus.png"
                     sourceSize.width: 36; sourceSize.height: 36
                     anchors.centerIn: parent
                     visible: style == "PRINTER_RECT"

                     MouseArea {
                         anchors.fill: parent
                         onClicked: {
                             var index = 0;
                             while (index < printerGrid.model.count) {
                                 if (pid == printerGrid.model.get(index).pid) {
                                     if (printerGrid.model.get(index).active == 1) {
                                         printerGrid.model.remove(index);
                                         printerGrid.model.get(0).active = 1;
                                         printerDetailLoader.source = "";
                                         printerDetailLoader.source = "qrc:/qml/PrinterDetail.qml";
                                     }
                                     else {
                                         printerGrid.model.remove(index);
                                     }
                                     break;
                                 }
                                 index++;
                             }
                         }
                     }
                 }

                 Image {
                     id: addButton
                     source: "qrc:/images/add.png"
                     sourceSize.width: 36; sourceSize.height: 36
                     anchors.centerIn: parent
                     visible: style == "ADD_RECT"

                     MouseArea {
                         anchors.fill: parent
                         onClicked: {
                             foreground.visible = true;
                             addPrinterDialog.visible = true;
                             addPrinterDialog.y = 275;
                         }
                     }
                 }
             }
        }
    }
}
