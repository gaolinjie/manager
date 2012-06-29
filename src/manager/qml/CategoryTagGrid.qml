import QtQuick 1.0
import "../js/global.js" as Global

GridView {
    id: categoryTagGrid
    model: categoryTagModel
    delegate: categoryTagDelegate
    cellWidth: 90
    cellHeight: 29
    width: 300
    height: 300
    interactive: false

    Component {
        id: categoryTagDelegate

        Item {
            id: wrapper
            Tag {
                id: tag
                name: cate
                visible: cid != -1
                z: 1
            }

            Image {
                id: addTag
                source: "qrc:/images/tag_add.png"
                visible: cid == -1
                z: 1

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        selectCategoryRect.visible = true;
                    }
                }
            }

            Rectangle {
                id: selectCategoryRect
                width: 150
                height: 300
                anchors.left: addTag.right; anchors.leftMargin: 5
                anchors.verticalCenter: addTag.verticalCenter
                color: "#463881"
                radius: 5
                border.color: "white"
                border.width: 2
                visible: false
                z: 13

                Text {
                    id: selectCategoryTitle
                    anchors.left: parent.left; anchors.leftMargin: 15
                    anchors.top: parent.top; anchors.topMargin: 20
                    text: "请选择菜品类别:"
                    font.pixelSize: 15
                    color: "white"
                }

                CategoryListView {
                    id: categoryListView
                    anchors.left: selectCategoryTitle.left; anchors.leftMargin: 10
                    anchors.top: selectCategoryTitle.bottom; anchors.topMargin: 20
                }
            }
        }
    }

    ListModel {
        id: categoryTagModel
        Component.onCompleted: loadItemsData()
        //Component.onDestruction: saveItemsData()
        function loadItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS categoryTagModel(cid INTEGER primary key, cate TEXT)');
                    var rs = tx.executeSql('SELECT * FROM categoryTagModel');
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            categoryTagModel.append({"cid": item.cid,
                                              "cate": item.cate});
                            index++;
                        }
                    }
                    else {
                        /*categoryTagModel.append({"cid": 0,
                                          "cate": "特色"});
                        categoryTagModel.append({"cid": 1,
                                          "cate": "套餐"});
                        categoryTagModel.append({"cid": 2,
                                          "cate": "推荐"});
                        categoryTagModel.append({"cid": 3,
                                          "cate": "炒菜"});
                        categoryTagModel.append({"cid": 4,
                                          "cate": "干锅"});
                        categoryTagModel.append({"cid": 5,
                                          "cate": "凉菜"});
                        categoryTagModel.append({"cid": 6,
                                          "cate": "酒水"});*/
                    }
                    categoryTagModel.append({"cid": -1,
                                      "cate": ""});
                }
            )
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE categoryTagModel');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS categoryTagModel(cid INTEGER primary key, cate TEXT)');
                    var index = 0;
                    while (index < categoryTagModel.count && categoryTagModel.get(index).cid != -1) {
                        var item = categoryTagModel.get(index);
                        tx.executeSql('INSERT INTO categoryTagModel VALUES(?,?)', [item.cid, item.cate]);
                        index++;
                    }
                }
            )
        }
    }
}
