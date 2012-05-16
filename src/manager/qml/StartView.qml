// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

GridView {
    id: startView
    width: 1000; height: 480
    cellWidth: 310
    cellHeight: 160
    model: startModel
    delegate: startDelegate
    cacheBuffer: 1000
    smooth: true
    flow: GridView.TopToBottom



    Component {
        id: startDelegate
        Item {
            id: wraper
            width: 300; height: 150

            Component.onCompleted: {
                var component;
                if (style == "IMAGE_RECT") {
                    component = Qt.createComponent("ImageRect.qml");
                    component.createObject(wraper, {"iconSource": image, "iconTitle": title});

                }
                else if (style == "ICON_RECT") {
                    component = Qt.createComponent("IconRect.qml");
                    component.createObject(wraper, {"iconSource": image, "iconTitle": title});
                }
                else {
                    component = Qt.createComponent("AddRect.qml");
                    component.createObject(wraper);
                }
            }
        }
    }

    ListModel {
        id: startModel
        Component.onCompleted: loadItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS startModel(cid INTEGER primary key, title TEXT, image TEXT, style TEXT, slotQml TEXT, backColor TEXT, foreColor TEXT)');
                    var rs = tx.executeSql('SELECT * FROM startModel');
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            startModel.append({"cid": item.cid, "title": item.title, "image": item.image, "style": item.style, "slotQml": item.slotQml, "backColor": item.backColor, "foreColor": item.foreColor});
                            index++;
                        }
                    }
                    startModel.append({"cid": 1, "title": "", "image": "qrc:/images/add.png", "style": "ADD_RECT", "slotQml": "manager.qml", "backColor": "", "foreColor": ""});
                }
            )
        }
    }
}
