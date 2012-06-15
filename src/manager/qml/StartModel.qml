// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    id: startModel
    Component.onCompleted: loadItemsData()
    Component.onDestruction: saveItemsData()
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS startModel(cid INTEGER primary key, title TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                tx.executeSql('CREATE TABLE IF NOT EXISTS itemModel(iid INTEGER primary key, cid INTEGER, tag TEXT, name TEXT, image TEXT, detail TEXT, price REAL)');
                var rs = tx.executeSql('SELECT * FROM startModel');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        var rss = tx.executeSql('SELECT * FROM itemModel where cid = ?', [item.cid]);
                        if (rss.rows.length > 0) {
                            item.image = rss.rows.item(0).image;
                        }
                        startModel.append({"cid": item.cid, "title": item.title, "image": item.image, "style": item.style, "slotQml": item.slotQml, "backColor": item.backColor, "foreColor": item.foreColor});
                        index++;
                    }
                }
                startModel.append({"cid": index, "title": "", "image": "qrc:/images/add.png", "style": "ADD_RECT", "slotQml": "manager.qml", "backColor": "", "foreColor": ""});
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('DROP TABLE startModel');
                tx.executeSql('CREATE TABLE IF NOT EXISTS startModel(cid INTEGER primary key, title TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                var index = 0;
                while (index < startModel.count && startModel.get(index).style != "ADD_RECT") {
                    startModel.get(index).cid = index;
                    var item = startModel.get(index);
                    tx.executeSql('INSERT INTO startModel VALUES(?,?,?,?,?,?,?)', [item.cid, item.title, item.image, item.style, item.slotQml, item.backColor, item.foreColor]);
                    index++;
                }
            }
        )
    }
}
