import QtQuick 1.0
import "../js/global.js" as Global

GridView {
    id: seatView
    model: seatModel
    delegate: seatDelegate
    cacheBuffer: 100
    cellWidth: 360
    cellHeight: 85
    width: 1000
    height: 470
    flow: GridView.TopToBottom
    x: 100
    Component.onCompleted: {
        seatView.x = 0;
        parent.contentModel = seatView.model;
    }
    signal clearEdit()
    signal refreshEdit()

    Behavior on x {
        NumberAnimation { duration: 200; easing.type: Easing.OutQuint}
    }

    Component {
        id: seatDelegate

        Rectangle {
             width: 330; height: 60
             color: "#de9317"//active == 1 ? "black" : "#359533"
             smooth: true
             //opacity: 0.8
/*
             Image {
                 id: labelImage
                 source: "qrc:/images/label.png"
             }*/

             Text {
                 id: seatText
                 text: seat
                 anchors.left: parent.left; anchors.leftMargin: 30
                 anchors.top: parent.top; anchors.topMargin: 5
                 color: "white"
                 font.pixelSize: 20
                 font.family: "微软雅黑"
                 smooth: true
             }

             Text {
                 id: categoryText
                 text: type
                 anchors.left: seatText.left
                 anchors.top: seatText.bottom; anchors.topMargin: 3
                 color: "white"
                 font.family: "微软雅黑"
                 smooth: true
                 font.pixelSize: 12
                 font.letterSpacing: 3
             }

             Text {
                 id: numText
                 text: capacity
                 anchors.right: numLabel.left; anchors.rightMargin: 5
                 anchors.bottom: numLabel.bottom; anchors.bottomMargin: -3
                 color: "white"
                 font.family: "微软雅黑"
                 smooth: true
                 font.pixelSize: 22
             }

             Text {
                 id: numLabel
                 text: "人座位"
                 anchors.right: parent.right; anchors.rightMargin: 50
                 anchors.bottom: categoryText.bottom; //anchors.topMargin: 3
                 color: "white"
                 font.family: "微软雅黑"
                 smooth: true
                 font.pixelSize: 14
             }

             Image {
                 id: editSeatIcon
                 source: "qrc:/images/edit.png"
                 sourceSize.width: 24
                 sourceSize.height: 24
                 anchors.right: deleteSeatIcon.right
                 anchors.top: parent.top
                 anchors.topMargin: 4
                 MouseArea {
                     anchors.fill: parent
                     onClicked: {
                         for (var i = 0; i < seatView.model.count; i++) {
                             if (seatView.model.get(i).sid == sid) {
                                 seatView.model.setProperty(i, "active", 1);
                             }
                             else {
                                 seatView.model.setProperty(i, "active", 0);
                             }
                         }

                         addSeatPanel.visible = true;
                         addSeatPanel.x = 880;
                         addSeatPanel.state = "editseat"
                         seatCategory.refreshEdit();
                     }
                 }
             }

             Image {
                 id: deleteSeatIcon
                 source: "qrc:/images/delete.png"
                 sourceSize.width: 24
                 sourceSize.height: 24
                 anchors.bottom: parent.bottom
                 anchors.bottomMargin: 4
                 anchors.right: parent.right
                 anchors.rightMargin: 10
                 MouseArea {
                     anchors.fill: parent
                     onClicked: {
                         if (seatView.model.count > 0) {
                             seatView.model.setProperty(0, "active", 1);
                         }

                         for (var i = 0; i < seatView.model.count; i++) {
                             if (seatView.model.get(i).sid == sid) {
                                 seatView.model.remove(i);
                             }
                         }
                     }
                 }
             }
        }
    }

    ListModel {
        id: seatModel
        Component.onCompleted: loadItemsData()
        Component.onDestruction: saveItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {/*
                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatTypeDB(stid TEXT key, name TEXT, active INTEGER)');
                    var rss = tx.executeSql('SELECT * FROM seatTypeDB WHERE active = ?', [1]);
                    if (rss.rows.length > 0) {
                        var item = rss.rows.item(0);
                        Global.seatType = item.stid;
                    }*/

                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatItemDB(sid TEXT key, stid TEXT, seat TEXT, type TEXT, capacity INTEGER, active INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM seatItemDB WHERE stid = ?', [Global.seatType]);
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            seatModel.append({"sid": item.sid,
                                              "stid": item.stid,
                                              "seat": item.seat,
                                              "type": item.type,
                                              "capacity": item.capacity,
                                              "active": item.active});
                            index++;
                        }
                    }
                }
            )
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                   tx.executeSql('CREATE TABLE IF NOT EXISTS seatItemDB(sid TEXT key, stid TEXT, seat TEXT, type TEXT, capacity INTEGER, active INTEGER)');
                   tx.executeSql('DELETE FROM seatItemDB WHERE stid = ? ', [Global.seatType]);
                   var index = 0;
                   while (index < seatModel.count) {
                       var item = seatModel.get(index);
                       tx.executeSql('INSERT INTO seatItemDB VALUES(?,?,?,?,?,?)', [item.sid, item.stid, item.seat, item.type, item.capacity, item.active]);
                       index++;
                   }
                }
            )
        }
    }
}

/*else {
    seatModel.append({"sid": 0,
                      "tid": 0,
                      "seat": "001 号",
                      "active": 0});
    seatModel.append({"sid": 1,
                         "tid": 0,
                      "seat": "002 号",
                         "active": 0});
    seatModel.append({"sid": 2,
                         "tid": 0,
                      "seat": "003 号",
                         "active": 0});
    seatModel.append({"sid": 3,
                         "tid": 0,
                      "seat": "004 号",
                         "active": 0});
    seatModel.append({"sid": 4,
                         "tid": 0,
                      "seat": "005 号",
                         "active": 0});
    seatModel.append({"sid": 5,
                         "tid": 0,
                      "seat": "006 号",
                         "active": 0});
    seatModel.append({"sid": 6,
                         "tid": 0,
                      "seat": "007 号",
                         "active": 0});
    seatModel.append({"sid": 7,
                         "tid": 0,
                      "seat": "008 号",
                         "active": 0});
    seatModel.append({"sid": 8,
                         "tid": 0,
                      "seat": "009 号",
                         "active": 0});
    seatModel.append({"sid": 9,
                         "tid": 0,
                      "seat": "010 号",
                         "active": 0});
    seatModel.append({"sid": 10,
                         "tid": 0,
                      "seat": "011 号",
                         "active": 0});
    seatModel.append({"sid": 11,
                         "tid": 0,
                      "seat": "012 号",
                         "active": 0});
    seatModel.append({"sid": 12,
                         "tid": 1,
                      "seat": "吉 祥 厅",
                         "active": 0});
    seatModel.append({"sid": 13,
                         "tid": 1,
                      "seat": "如 意 厅",
                         "active": 0});
    seatModel.append({"sid": 14,
                         "tid": 1,
                      "seat": "功 成 厅",
                         "active": 0});
    seatModel.append({"sid": 15,
                         "tid": 1,
                      "seat": "名 就 厅",
                         "active": 0});
    seatModel.append({"sid": 16,
                         "tid": 1,
                      "seat": "花 好 厅",
                         "active": 0});
    seatModel.append({"sid": 17,
                         "tid": 1,
                      "seat": "月 圆 厅",
                         "active": 0});
    seatModel.append({"sid": 18,
                         "tid": 1,
                      "seat": "福 禄 厅",
                         "active": 0});
    seatModel.append({"sid": 19,
                         "tid": 1,
                      "seat": "亨 通 厅",
                         "active": 0});
    seatModel.append({"sid": 20,
                         "tid": 1,
                      "seat": "荣 华 厅",
                         "active": 0});
    seatModel.append({"sid": 21,
                         "tid": 1,
                      "seat": "富 贵 厅",
                         "active": 0});
    seatModel.append({"sid": 22,
                         "tid": 1,
                      "seat": "财 寿 厅",
                         "active": 0});
    seatModel.append({"sid": 23,
                         "tid": 1,
                      "seat": "康 宁 厅",
                         "active": 0});
    seatModel.append({"sid": 24,
                         "tid": 2,
                      "seat": "VIP 001",
                         "active": 0});
    seatModel.append({"sid": 25,
                         "tid": 2,
                      "seat": "VIP 002",
                         "active": 0});
    seatModel.append({"sid": 26,
                         "tid": 2,
                      "seat": "VIP 003",
                         "active": 0});
    seatModel.append({"sid": 27,
                         "tid": 2,
                      "seat": "VIP 004",
                         "active": 0});
    seatModel.append({"sid": 28,
                         "tid": 2,
                      "seat": "VIP 005",
                         "active": 0});
    seatModel.append({"sid": 29,
                         "tid": 2,
                      "seat": "VIP 006",
                         "active": 0});
    seatModel.append({"sid": 30,
                         "tid": 3,
                      "seat": "订 座 001",
                         "active": 0});
    seatModel.append({"sid": 31,
                         "tid": 3,
                      "seat": "订 座 002",
                         "active": 0});
    seatModel.append({"sid": 32,
                         "tid": 3,
                      "seat": "订 座 003",
                         "active": 0});
    seatModel.append({"sid": 33,
                         "tid": 3,
                      "seat": "订 座 004",
                         "active": 0});
    seatModel.append({"sid": 34,
                         "tid": 3,
                      "seat": "订 座 005",
                         "active": 0});
    seatModel.append({"sid": 35,
                         "tid": 3,
                      "seat": "订 座 006",
                         "active": 0});
}*/
