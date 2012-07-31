// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    id: printerModel
    Component.onCompleted: loadItemsData()
    Component.onDestruction: saveItemsData()
    property bool readOnly: false
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS printerDB(pid TEXT primary key, name TEXT, active INTEGER)');
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
                if (printerModel.readOnly == false) {
                    printerModel.append({"pid": "", "name": "", "active": 0, "style": "ADD_RECT"});
                }
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('DROP TABLE printerDB');
                tx.executeSql('CREATE TABLE IF NOT EXISTS printerDB(pid TEXT primary key, name TEXT, active INTEGER, style TEXT)');
                var index = 0;
                while (index < printerModel.count && printerModel.get(index).style != "ADD_RECT") {
                    //printerModel.get(index).pid = index;
                    var item = printerModel.get(index);
                    tx.executeSql('INSERT INTO printerDB VALUES(?,?,?,?)', [item.pid, item.name, item.active, item.style]);
                    index++;
                }
            }
        )
    }
}
