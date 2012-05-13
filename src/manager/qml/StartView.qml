// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: startView
    width: 1000; height:500
    model: startModel
    delegate: startDelegate
    orientation: ListView.Horizontal
    cacheBuffer: 1000
    spacing: 6
    smooth: true
    section.property: "segment"
    section.criteria: ViewSection.FullString
    section.delegate: startSpace

    Component {
        id: startSpace
        Item {
            width: 60
            height: 10
        }
    }

    Component {
        id: startDelegate

        Item {
            width: 300; height: 465
            Column {
                id: col
                spacing: 6

                Repeater {
                    model: column

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
                                item2.image = "qrc:/images/add.png";
                                item2.style = "ADD_RECT";
                                item2.slotQml = "manager.qml";
                            }
                            else if (index + 1 == rs.rows.length) {
                                item1.image = "qrc:/images/add.png";
                                item1.style = "ADD_RECT";
                                item1.slotQml = "manager.qml";
                                item1 = '';
                            }
                            else {
                                item1 = rs.rows.item(index+1);
                                item2 = rs.rows.item(index+2);
                            }

                            startModel.append({"segment": Math.floor(index/9),
                                               "column": [{"cid": item0.cid, "title": item0.title, "image": item0.image, "style": item0.style, "slotQml": item0.slotQml, "rectColor": item0.rectColor, "hotColor": item0.hotColor},
                                                          {"cid": item1.cid, "title": item1.title, "image": item1.image, "style": item1.style, "slotQml": item1.slotQml, "rectColor": item1.rectColor, "hotColor": item1.hotColor},
                                                          {"cid": item2.cid, "title": item2.title, "image": item2.image, "style": item2.style, "slotQml": item2.slotQml, "rectColor": item2.rectColor, "hotColor": item2.hotColor}]});

                            if (index + 3 == rs.rows.length) {
                                startModel.append({"segment": Math.floor(index/9) + 1,
                                                   "column": [{"cid": 1, "title": "", "image": "qrc:/images/add.png", "style": "ADD_RECT", "slotQml": "manager.qml", "rectColor": "", "hotColor": ""}]});
                            }

                            index+=3;
                        }
                    } else {
                        startModel.append({"segment": 0,
                                           "column": [{"cid": 1, "title": "", "image": "qrc:/images/add.png", "style": "ADD_RECT", "slotQml": "manager.qml", "rectColor": "", "hotColor": ""}]});
                    }
                }
            )
        }
    }
}
