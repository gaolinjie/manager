import QtQuick 1.0
import "../js/global.js" as Global

ListModel {
    id: startModel
    Component.onCompleted: loadItemsData()
//  Component.onDestruction: saveItemsData()
    function loadItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('CREATE TABLE IF NOT EXISTS startModel(cid INTEGER primary key, title TEXT, image TEXT, style TEXT, slotQml TEXT, rectColor TEXT, hotColor TEXT)');
                var rs = tx.executeSql('SELECT * FROM startModel');
                var index = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item0 = rs.rows.item(index);
                        var item1;
                        var item2;
                        if (index + 2 == rs.rows.length) {
                            item1 = rs.rows.item(index+1);
                            item2 = '';
                        }
                        else if (index + 1 == rs.rows.length) {                         
                            item1 = '';
                            item2 = '';
                        }
                        else {
                            item1 = rs.rows.item(index+1);
                            item2 = rs.rows.item(index+2);
                        }

                        startModel.append({"segment": Math.floor(index/9),
                                           "column": [{"cid": item0.cid, "title": item0.title, "image": item0.image, "style": item0.style, "slotQml": item0.slotQml, "rectColor": item0.rectColor, "hotColor": item0.hotColor},
                                                      {"cid": item1.cid, "title": item1.title, "image": item1.image, "style": item1.style, "slotQml": item1.slotQml, "rectColor": item1.rectColor, "hotColor": item1.hotColor},
                                                      {"cid": item2.cid, "title": item2.title, "image": item2.image, "style": item2.style, "slotQml": item2.slotQml, "rectColor": item2.rectColor, "hotColor": item2.hotColor}]});
                        index+=3;
                    }
                } else {
                    startModel.append({"segment": 0,
                                       "column": [{"cid": 0, "title": "购物车", "image": "qrc:/images/note.png", "style": "ICON_RECT", "slotQml": "manager.qml", "rectColor": "#5859b9", "hotColor": "#d54d34"},
                                                  {"cid": 1, "title": "", "image": "qrc:/images/add.png", "style": "ADD_RECT", "slotQml": "manager.qml", "rectColor": "", "hotColor": ""}
                                                  ]});
                }
            }
        )
    }

    function saveItemsData() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                tx.executeSql('DROP TABLE startModel');
                tx.executeSql('CREATE TABLE IF NOT EXISTS startModel(cid INTEGER primary key, title TEXT, image TEXT, style TEXT, slotQml TEXT, rectColor TEXT, hotColor TEXT)');
                var index = 0;
                while (index < startModel.count) {
                    var item0 = startModel.get(index).column.get(0);
                    var item1 = startModel.get(index).column.get(1);
                    var item2 = startModel.get(index).column.get(2);
                    tx.executeSql('INSERT INTO startModel VALUES(?,?,?,?,?,?,?)', [item0.cid, item0.title, item0.image, item0.style, item0.slotQml, item0.rectColor, item0.hotColor]);
                    tx.executeSql('INSERT INTO startModel VALUES(?,?,?,?,?,?,?)', [item1.cid, item1.title, item1.image, item1.style, item1.slotQml, item1.rectColor, item1.hotColor]);
                    tx.executeSql('INSERT INTO startModel VALUES(?,?,?,?,?,?,?)', [item2.cid, item2.title, item2.image, item2.style, item2.slotQml, item2.rectColor, item2.hotColor]);
                    index++;
                }
            }
        )
    }
}
