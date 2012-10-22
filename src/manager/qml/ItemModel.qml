// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

ListModel {
    id: itemModel
    Component.onCompleted: loadItemsData()
    Component.onDestruction: saveItemsData()
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuItemDB(iid TEXT primary key, tid TEXT, type TEXT, name TEXT, image TEXT, detail TEXT, price REAL, print INTEGER, printer TEXT)');
                var rs = tx.executeSql('SELECT * FROM menuItemDB where tid = ?', [Global.tid]);
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        itemModel.append({"iid": item.iid, "tid": item.tid, "type": item.type, "name": item.name, "image": item.image, "detail": item.detail, "price": item.price, "print": item.print, "printer": item.printer, "style": "IMAGE_RECT"});
                        index++;
                    }
                }
                itemModel.append({"iid": index, "tid": 0, "type": "", "name": "", "image": "qrc:/images/add_rect.png", "detail": "", "price": 0, "print": 0, "printer": "", "style": "ADD_RECT"});
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                //tx.executeSql('DROP TABLE menuItemDB');
                tx.executeSql('CREATE TABLE IF NOT EXISTS menuItemDB(iid TEXT primary key, tid TEXT, type TEXT, name TEXT, image TEXT, detail TEXT, price REAL, print INTEGER, printer TEXT)');
                tx.executeSql('DELETE FROM menuItemDB WHERE tid = ? ', [Global.tid]);
                var index = 0;
                while (index < itemModel.count && itemModel.get(index).style != "ADD_RECT") {
                    var item = itemModel.get(index);
                    tx.executeSql('INSERT INTO menuItemDB VALUES(?,?,?,?,?,?,?,?,?)', [item.iid, item.tid, item.type, item.name, item.image, item.detail, item.price, item.print, item.printer]);
                    index++;
                }
            }
        )
    }
}
