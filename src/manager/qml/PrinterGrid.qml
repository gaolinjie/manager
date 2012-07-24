import QtQuick 1.0
import "../js/global.js" as Global

GridView {
    id: printerGrid
    model: printerModel
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
                     font.pixelSize: 18
                 }

                 Text {
                     id: addText
                     text: "点击右边按钮添加打印机"
                     anchors.left: parent.left; anchors.leftMargin: 30
                     anchors.verticalCenter: parent.verticalCenter
                     color: active == 1 ? "white" : "black"
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

    ListModel {
        id: printerModel
        Component.onCompleted: loadItemsData()
        Component.onDestruction: saveItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerDB(pid INTEGER primary key, name TEXT, active INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM printerDB');
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            printerModel.append({"pid": item.pid,
                                              "name": item.name,
                                              "active": item.active,
                                                    "style": item.style});
                            index++;
                        }
                    }
                    else {
                    }
                    printerModel.append({"pid": index, "name": "", "active": 0, "style": "ADD_RECT"});
                }
            )
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE printerDB');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerDB(pid INTEGER primary key, name TEXT, active INTEGER, style TEXT)');
                    var index = 0;
                    while (index < printerModel.count && printerModel.get(index).style != "ADD_RECT") {
                        printerModel.get(index).pid = index;
                        var item = printerModel.get(index);
                        tx.executeSql('INSERT INTO printerDB VALUES(?,?,?,?)', [item.pid, item.name, item.active, item.style]);
                        index++;
                    }
                }
            )
        }
    }
}
