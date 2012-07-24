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
                tx.executeSql('CREATE TABLE IF NOT EXISTS itemDB(iid INTEGER primary key, cid INTEGER, tag TEXT, name TEXT, image TEXT, detail TEXT, price REAL, needPrint INTEGER, printer TEXT)');
                var rs = tx.executeSql('SELECT * FROM itemDB where cid = ?', [Global.cid]);
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        itemModel.append({"iid": item.iid, "cid": item.cid, "tag": item.tag, "name": item.name, "image": item.image, "detail": item.detail, "price": item.price, "needPrint": item.needPrint, "printer": item.printer, "style": "IMAGE_RECT"});
                        index++;
                    }
                }
                itemModel.append({"iid": index, "cid": 0, "tag": "", "name": "", "image": "qrc:/images/add_rect.png", "detail": "", "price": 0, "needPrint": 0, "printer": "", "style": "ADD_RECT"});
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                //tx.executeSql('DROP TABLE itemDB');
                tx.executeSql('CREATE TABLE IF NOT EXISTS itemDB(iid INTEGER primary key, cid INTEGER, tag TEXT, name TEXT, image TEXT, detail TEXT, price REAL, needPrint INTEGER, printer TEXT)');
                tx.executeSql('DELETE FROM itemDB WHERE cid = ? ', [Global.cid]);
                var rs = tx.executeSql('SELECT * FROM itemDB');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        tx.executeSql('UPDATE itemDB SET iid = ? WHERE iid = ?', [index, item.iid]);
                        index++;
                    }
                }

                rs = tx.executeSql('SELECT * FROM itemDB');
                index = 0;
                while (index < itemModel.count && itemModel.get(index).style != "ADD_RECT") {
                    itemModel.get(index).iid = index + rs.rows.length;
                    var item = itemModel.get(index);
                    tx.executeSql('INSERT INTO itemDB VALUES(?,?,?,?,?,?,?,?,?)', [item.iid, item.cid, item.tag, item.name, item.image, item.detail, item.price, item.needPrint, item.printer]);
                    index++;
                }
            }
        )
    }
}
