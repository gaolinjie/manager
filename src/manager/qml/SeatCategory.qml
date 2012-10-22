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
    signal clearEdit()
    signal refreshEdit()
    interactive: false

    Component {
        id: seatCategoryDelegate
        Item {
            id: seatCategoryWrapper
            width: 200; height: 40

            Rectangle {
                 id: seatCategoryRect
                 width: 200; height: 40
                 color: active == 0 ? "#de9317" : "#5859b9"

                 Text {
                     text: name
                     //anchors.centerIn: parent
                     anchors.left: parent.left
                     anchors.leftMargin: 20
                     anchors.verticalCenter: parent.verticalCenter
                     color: "white"//active == 1 ? "white" : "black"
                     font.pixelSize: 18
                     font.family: "微软雅黑"
                     font.letterSpacing: 3
                     smooth: true
                 }

                 MouseArea {
                     anchors.fill: parent
                     onClicked: {
                         for (var i = 0; i < seatCategory.model.count; i++) {
                             if (seatCategory.model.get(i).stid == stid) {
                                 seatCategory.model.setProperty(i, "active", 1);
                             }
                             else {
                                 seatCategory.model.setProperty(i, "active", 0);
                             }
                         }
                         //Global.seatType = stid;
                         //console.log(Global.seatType)
                         seatCategory.changeSeatType();
                     }
                 }
            }

            Image {
                id: editCategoryIcon
                source: "qrc:/images/edit.png"
                sourceSize.width: 24
                sourceSize.height: 24
                anchors.verticalCenter: seatCategoryRect.verticalCenter
                anchors.right: deleteCategoryIcon.left
                anchors.rightMargin: 5

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        for (var i = 0; i < seatCategory.model.count; i++) {
                            if (seatCategory.model.get(i).stid == stid) {
                                seatCategory.model.setProperty(i, "active", 1);
                            }
                            else {
                                seatCategory.model.setProperty(i, "active", 0);
                            }
                        }
                        seatCategory.changeSeatType();

                        addSeatPanel.visible = true;
                        addSeatPanel.x = 880;
                        addSeatPanel.state = "edittype"
                        seatCategory.refreshEdit();
                    }
                }
            }

            Image {
                id: deleteCategoryIcon
                source: "qrc:/images/delete.png"
                sourceSize.width: 24
                sourceSize.height: 24
                anchors.verticalCenter: seatCategoryRect.verticalCenter
                anchors.right: seatCategoryRect.right
                anchors.rightMargin: 10
                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if (active == 1) {
                            seatView.contentModel.clear();
                            for (var i = 0; i < seatCategory.model.count; i++) {
                                if (seatCategory.model.get(i).stid == stid) {
                                    seatCategory.model.remove(i);
                                }
                            }
                            if (seatCategory.model.count > 0) {
                                seatCategory.model.setProperty(0, "active", 1);
                            }
                            seatCategory.changeSeatType();
                        }
                        else {
                            for (var i = 0; i < seatCategory.model.count; i++) {
                                if (seatCategory.model.get(i).stid == stid) {
                                    seatCategory.model.remove(i);
                                }
                            }
                            deleteItemsData();
                        }
                    }
                    function deleteItemsData() {
                        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
                        db.transaction(
                            function(tx) {
                               tx.executeSql('CREATE TABLE IF NOT EXISTS seatItemDB(sid TEXT key, stid TEXT, seat TEXT, type TEXT, capacity INTEGER, active INTEGER)');
                               tx.executeSql('DELETE FROM seatItemDB WHERE stid = ? ', [stid]);
                            }
                        )
                    }
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
                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatTypeDB(stid TEXT key, name TEXT, active INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM seatTypeDB');
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            if (item.active == 1) {
                                Global.seatType = item.stid;
                            }
                            seatCategoryModel.append({"stid": item.stid,
                                                      "name": item.name,
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
                    tx.executeSql('DROP TABLE seatTypeDB');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS seatTypeDB(stid TEXT key, name TEXT, active INTEGER)');
                    var index = 0;
                    while (index < seatCategoryModel.count) {
                        var item = seatCategoryModel.get(index);
                        tx.executeSql('INSERT INTO seatTypeDB VALUES(?,?,?)', [item.stid, item.name, item.active]);
                        index++;
                    }
                }
            )
        }
    }
}
