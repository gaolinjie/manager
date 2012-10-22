// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

ListModel {
    id: menuGridModel
    Component.onCompleted: loadItemsData()
    Component.onDestruction: saveItemsData()
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuTypeDB(tid TEXT primary key, type TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuItemDB(iid TEXT primary key, tid TEXT, type TEXT, name TEXT, image TEXT, detail TEXT, price REAL, print INTEGER, printer TEXT)');
                var rs = tx.executeSql('SELECT * FROM menuTypeDB');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        var rss = tx.executeSql('SELECT * FROM menuItemDB where tid = ?', [item.tid]);
                        if (rss.rows.length > 0) {
                            if (item.style == "IMAGE_RECT") {
                                item.image = rss.rows.item(0).image;
                            }
                        }
                        else {
                            if (item.style == "IMAGE_RECT") {
                                item.image = "";
                            }
                        }
                        menuGridModel.append({"tid": item.tid, "type": item.type, "image": item.image, "style": item.style, "slotQml": item.slotQml, "backColor": item.backColor, "foreColor": item.foreColor});
                        index++;
                    }
                }
                menuGridModel.append({"tid": index, "type": "", "image": "qrc:/images/add_rect.png", "style": "ADD_RECT", "slotQml": "ManagerView.qml", "backColor": "", "foreColor": ""});
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('DROP TABLE menuTypeDB');
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuTypeDB(tid TEXT primary key, type TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                var index = 0;
                while (index < menuGridModel.count && menuGridModel.get(index).style != "ADD_RECT") {
                    //menuGridModel.get(index).tid = index;
                    var item = menuGridModel.get(index);
                    tx.executeSql('INSERT INTO menuTypeDB VALUES(?,?,?,?,?,?,?)', [item.tid, item.type, item.image, item.style, item.slotQml, item.backColor, item.foreColor]);
                    index++;
                }
            }
        )
    }

    function reloadItemsData() {
        menuGridModel.clear();
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuTypeDB(tid TEXT primary key, type TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuItemDB(iid TEXT primary key, tid TEXT, type TEXT, name TEXT, image TEXT, detail TEXT, price REAL, print INTEGER, printer TEXT)');
                var rs = tx.executeSql('SELECT * FROM menuTypeDB');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        var rss = tx.executeSql('SELECT * FROM menuItemDB where tid = ?', [item.tid]);
                        if (rss.rows.length > 0) {
                            if (item.style == "IMAGE_RECT") {
                                item.image = rss.rows.item(0).image;
                            }
                        }
                        else {
                            if (item.style == "IMAGE_RECT") {
                                item.image = "";
                            }

                        }
                        menuGridModel.append({"tid": item.tid, "type": item.type, "image": item.image, "style": item.style, "slotQml": item.slotQml, "backColor": item.backColor, "foreColor": item.foreColor});
                        index++;
                    }
                }
                menuGridModel.append({"tid": index, "type": "", "image": "qrc:/images/add_rect.png", "style": "ADD_RECT", "slotQml": "ManagerView.qml", "backColor": "", "foreColor": ""});
            }
        )
    }
}
