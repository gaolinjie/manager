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

    Component {
        id: printerDelegate

        Rectangle {
             width: 320; height: 60
             color: active == 1 ? "#7B3349" : "#A3A5A0"

             Text {
                 id: nameText
                 text: name
                 anchors.left: parent.left; anchors.leftMargin: 30
                 anchors.top: parent.top; anchors.topMargin: 10
                 color: active == 1 ? "white" : "black"
                 font.pixelSize: 18
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
                                     printerGrid.model.remove(index);
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

             Text {
                 id: addText
                 text: "点击右边按钮添加打印机"
                 anchors.left: parent.left; anchors.leftMargin: 30
                 anchors.verticalCenter: parent.verticalCenter
                 color: active == 1 ? "white" : "black"
                 font.pixelSize: 18
                 visible: addButton.visible
             }
/*
             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     for (var i = 0; i < printerGrid.model.count; i++) {
                         if (printerGrid.model.get(i).pid == pid) {
                             printerGrid.model.setProperty(i, "active", 1);
                         }
                         else {
                             printerGrid.model.setProperty(i, "active", 0);
                         }
                     }
                 }
             }*/
        }
    }

    ListModel {
        id: printerModel
        Component.onCompleted: loadItemsData()
        //Component.onDestruction: saveItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerModel(pid INTEGER primary key, name TEXT, active INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM printerModel');
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
                        printerModel.append({"pid": 0,
                                          "name": "前台打印机",
                                          "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 1,
                                          "name": "厨房打印机 002 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 2,
                                          "name": "厨房打印机 003 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 3,
                                          "name": "厨房打印机 004 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 4,
                                          "name": "厨房打印机 005 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 5,
                                          "name": "厨房打印机 006 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                        printerModel.append({"pid": 6,
                                          "name": "厨房打印机 007 号",
                                             "active": 0,
                                                "style": "PRINTER_RECT"});
                    }
                    printerModel.append({"pid": index, "name": "", "active": 0, "style": "ADD_RECT"});
                }
            )
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE printerModel');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerModel(pid INTEGER primary key, name TEXT, active INTEGER, style TEXT)');
                    var index = 0;
                    while (index < printerModel.count && printerModel.get(index).style != "ADD_RECT") {
                        printerModel.get(index).pid = index;
                        var item = printerModel.get(index);
                        tx.executeSql('INSERT INTO printerModel VALUES(?,?,?,?)', [item.pid, item.name, item.active, item.style]);
                        index++;
                    }
                }
            )
        }
    }
}
