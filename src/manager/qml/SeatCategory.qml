import QtQuick 1.0
import "../js/global.js" as Global

ListView {
    id: seatCategory
    width: 1000; height: 44
    spacing: 10
    model: seatCategoryModel
    delegate: seatCategoryDelegate
    orientation: ListView.Horizontal
    cacheBuffer: 1000
    signal changeSeatType()

    Component {
        id: seatCategoryDelegate
        Rectangle {
             width: 200; height: 40
             color: active == 1 ? "#de9317" : "#5859b9"

             Text {
                 text: type
                 anchors.centerIn: parent
                 color: "white"//active == 1 ? "white" : "black"
                 font.pixelSize: 16
                 font.family: "微软雅黑"
                 smooth: true
             }

             MouseArea {
                 anchors.fill: parent

                 onClicked: {
                     Global.seatType = cid;
                     for (var i = 0; i < seatCategory.model.count; i++) {
                         if (seatCategory.model.get(i).cid == cid) {
                             seatCategory.model.setProperty(i, "active", 1);
                         }
                         else {
                             seatCategory.model.setProperty(i, "active", 0);
                         }
                     }
                     seatCategory.changeSeatType();
                 }
             }
        }
    }

    ListModel {
        id: seatCategoryModel
        Component.onCompleted: loadItemsData()
        Component.onDestruction: saveItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatTypeDB(cid INTEGER key, type TEXT, active INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM seatTypeDB');
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            if (item.active == 1) {
                                Global.seatType = item.cid;
                            }
                            seatCategoryModel.append({"cid": item.cid,
                                                      "type": item.type,
                                                      "active": item.active});
                            index++;
                        }
                    }
                    else {
                        seatCategoryModel.append({"cid": 0,
                                           "type": "大 厅",
                                           "active": 1});
                        seatCategoryModel.append({"cid": 1,
                                           "type": "包 厢",
                                           "active": 0});
                        seatCategoryModel.append({"cid": 2,
                                           "type": "VIP",
                                           "active": 0});
                        seatCategoryModel.append({"cid": 3,
                                           "type": "订 座",
                                           "active": 0});
                    }
                }
            )
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE seatTypeDB');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatTypeDB(cid INTEGER key, type TEXT, active INTEGER)');
                    var index = 0;
                    while (index < seatCategoryModel.count) {
                        var item = seatCategoryModel.get(index);
                        tx.executeSql('INSERT INTO seatTypeDB VALUES(?,?,?)', [item.cid, item.type, item.active]);
                        index++;
                    }
                }
            )
        }
    }
}
