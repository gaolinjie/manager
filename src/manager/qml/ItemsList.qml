import QtQuick 1.0
import "../js/global.js" as Global
import "../js/calculator.js" as CalcEngine
ListView {
        id: itemsList
        width: 355; height:250
        model: itemsModel
        delegate: itemDelegate
        smooth: true
        signal orderListUpdateSignal()

        Connections {
            target: parent.parent
            onMainAddsignal: {

                updateItemsModelData();
                itemsList.currentIndex = Global.gitemIndex
                updateOrderListData();
            }
        }
        Connections {
            target: parent.parent
            onMainUpdateItemsignal: {
                loadItemsData();
                Global.gitemIndex = 0;
            }
        }
        Connections {
            target: parent.parent
            onMainCooksignal: {
                mergeItemData();
                loadItemsData();
                Global.gitemIndex = 0;
            }
        }


        ListModel{
            id: itemsModel
        }

        Component {
            id: itemDelegate

            Item {
                id: wraper
                width: 355; height: 30

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        wraper.ListView.view.currentIndex = index
                        Global.gitemIndex = index
                    }
                }

                Rectangle {
                    id: itemRect
                    width: 360; height: 30
                    radius: 8
                    anchors.left: parent.left; anchors.leftMargin: 35
                    anchors.verticalCenter: parent.verticalCenter
                    color: cookbool==0 ? "white" : "grey"
                    smooth: true
                    border.color:cookbool==0 ?"red": "black"
                    border.width: 1
                    Rectangle{
                        id: itemOverRect
                        width: 360; height: 30
                        radius: 8
                        anchors.centerIn: parent
                        color: "#f4a83d"
                        opacity: 0
                    }

                    Text {
                        id: nameText
                        text: name
                        font.family: "微软雅黑"
                        smooth: true
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 10
                        color: "black"
                    }

                    Text {
                        id: priceText
                        text: price
                        font.family: "微软雅黑"
                        smooth: true
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 120
                        color: "black"
                    }

                    Text {
                        id: numberText
                        text: num
                        font.family: "微软雅黑"
                        smooth: true
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 230
                        color: "black"
                    }

                    Text {
                        id: subtotalText
                        text: price * num
                        font.family: "微软雅黑"
                        smooth: true
                        font.pixelSize: 15
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.left: parent.left; anchors.leftMargin: 340
                        color: "black"
                    }
                    states: State {
                       name: "pressed"; when: wraper.ListView.isCurrentItem
                       PropertyChanges { target: itemOverRect; opacity: 0.3 }
                   }
                }

                Image {
                    source: "qrc:/images/minus2.png"
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.right: itemRect.left; anchors.rightMargin: 5
                    visible: wraper.ListView.isCurrentItem && Global.pay ==0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            wraper.ListView.view.minusItemData()
                            wraper.ListView.view.updateOrderListData()
                        }
                    }
                }

                Image {
                    source: "qrc:/images/add.png"
                    width: 31; height: 31
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: itemRect.right; anchors.leftMargin: 5
                    visible: wraper.ListView.isCurrentItem && Global.pay==0
                    MouseArea {
                        anchors.fill: parent
                        onPressed: {
                            wraper.ListView.view.addItemData2()
                            wraper.ListView.view.loadItemsData()
                            wraper.ListView.view.currentIndex = Global.gitemIndex
                            wraper.ListView.view.updateOrderListData()
                        }
                    }
                 }
            }
        }

        function loadItemsData() {
            itemsModel.clear();
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS orderItemDB(oid TEXT key, iid TEXT, tid TEXT, type TEXT, name TEXT, image TEXT, price REAL, print INTEGER, printer TEXT, num INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM orderItemDB WHERE oid = ?', [Global.oid]);
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            itemsModel.append({"oid": item.oid,
                                               "iid": item.iid,
                                               "tid": item.tid,
                                               "type": item.type,
                                               "name": item.name,
                                               "image": item.image,
                                               "price": item.price,
                                               "print": item.print,
                                               "num": item.num,});

                            index++;
                        }
                    }
                }
            )
            itemsList.currentIndex = 0;
        }

        function saveItemsData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE orderItemDB');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS orderItemDB(oid TEXT key, iid TEXT, tid TEXT, type TEXT, name TEXT, image TEXT, price REAL, print INTEGER, printer TEXT, num INTEGER)');
                    var index = 0;
                    while (index < itemsModel.count) {
                        var item = itemsModel.get(index);
                        tx.executeSql('INSERT INTO orderItemDB VALUES(?,?,?,?,?,?,?,?,?,?)', [item.oid, item.iid, item.tid, item.type, item.name, item.image, item.price, item.print, item.printer, item.num]);
                        index++;
                    }
                }
            )
        }

        function updateItemsModelData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            var fname = Global.gorderItemsName;
            var fprice = Global.gorderItemsPrice;
            var ftype = Global.gorderItemsType;
            var fprintname = Global.gorderItemsprintname;
            var fprintbool = Global.gprintbool;
            var fcookbool = Global.gcookbool;
            var index = 0;
            var item;
            while (index < itemsModel.count) {
                item = itemsModel.get(index);
                if (item.name == Global.gorderItemsName && item.cookbool == fcookbool) break;
                index++;
            }
            //index = 0;///
            if ( index == itemsModel.count ) {
                itemsModel.append({"orderNO": Global.orderNO, "name": fname, "price": fprice, "num": 1,
                                  "type":ftype,"printname":fprintname,"printbool":fprintbool,"cookbool":fcookbool});

                db.transaction(
                    function(tx) {
                            tx.executeSql('INSERT INTO orderItemDB VALUES(?,?,?,?,?,?,?,?)', [Global.orderNO,fname, fprice, 1,ftype,fprintname,fprintbool,fcookbool]);
                        }
                  )
            }
            else {
                var itemnum = item.num;//item.num+1 = 11,item.num不能直接++操作，因此用中间量
                itemnum++;
                itemsModel.setProperty(index,"num",itemnum);
                db.transaction(
                    function(tx) {
                            tx.executeSql('UPDATE orderItemDB SET num = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [itemnum,Global.orderNO,item.name,item.cookbool]);
                        }
                  )
            }
            Global.gitemIndex = index ;
       }

       function minusItemData(){
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            var item;
            item = itemsModel.get(Global.gitemIndex);
            var itemnum = item.num;
            itemnum--;
            var itemname = item.name;
            var itemcookbool = item.cookbool;
            if ( itemnum == 0){
                itemsModel.remove(Global.gitemIndex);
                //saveItemsData();
                db.transaction(
                    function(tx) {
                            tx.executeSql('DELETE FROM orderItemDB WHERE orderNO = ? AND name = ? AND cookbool = ?', [Global.orderNO,itemname,itemcookbool]);////删除语句似乎不能直接用item.name,不知道为什么，需要用中间变量过渡
                            }
                  )
                if (Global.gitemIndex == itemsModel.count) Global.gitemIndex--;
                //else Global.gitemIndex++;
            }
            else{
                itemsModel.setProperty(Global.gitemIndex,"num",itemnum);
                db.transaction(
                    function(tx) {
                             //console.log(Global.orderNO);
                             //console.log(itemnum);
                            tx.executeSql('UPDATE orderItemDB SET num = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [itemnum,Global.orderNO,itemname,itemcookbool]);
                            //console.log(Global.orderNO);
                            //console.log(itemnum);
                        }
                  )
            }
       }

       function addItemData(){
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            var item;
            item = itemsModel.get(Global.gitemIndex);
            var itemnum = item.num;
            itemnum++;

            itemsModel.setProperty(Global.gitemIndex,"num",itemnum);
            //console.log(Global.gitemIndex)
            //console.log(itemnum)
            db.transaction(
                function(tx) {
                        tx.executeSql('UPDATE orderItemDB SET num = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [itemnum,Global.orderNO,item.name,item.cookbool]);
                         //    console.log(Global.orderNO)
                         //   console.log(item.name)
                    }
              )
       }

       function addItemData2(){
             var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
             var  item = itemsModel.get(Global.gitemIndex);
            db.transaction(
                function(tx) {
                var rs = tx.executeSql('SELECT * FROM orderItemDB WHERE orderNO = ? AND name = ? AND cookbool = ?', [Global.orderNO,item.name,0]);
                if (rs.rows.length > 0){
                     var item1=rs.rows.item(0);
                     var itemnum = item1.num;
                     itemnum++;
                     tx.executeSql('UPDATE orderItemDB SET num = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [itemnum,Global.orderNO,item.name,0]);
              }
             else {
                  tx.executeSql('INSERT INTO orderItemDB VALUES(?,?,?,?,?,?,?,?)', [Global.orderNO,item.name, item.price, 1,item.type,item.printname,item.printbool,0]);
              }
              var rs2 = tx.executeSql('SELECT * FROM orderItemDB WHERE orderNO = ?', [Global.orderNO]);
              var index = 0;
              while (index < rs2.rows.length){
                       var item1=rs2.rows.item(index);
                       if (item1.name == item.name && item1.cookbool == 0){Global.gitemIndex = index; break;}
                       else index++;
                }
            } )
        }

       function updateOrderListData() {
                Global.gorderTotalPrice = 0;////计算总价格
                var index = 0;
                var item;
                while (index < itemsModel.count) {
                    item = itemsModel.get(index);
                    var tempPrice = item.price;
                    var tempNum = item.num;
                    Global.gorderTotalPrice += (tempPrice*tempNum);
                    index++;
                }
                orderListUpdateSignal();
        }

        function mergeItemData() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                var rs = tx.executeSql('SELECT * FROM orderItemDB WHERE orderNO = ? AND cookbool = ?', [Global.orderNO,1]);
                var index = 0;
                while  (index< rs.rows.length){
                     var item=rs.rows.item(index);
                     var  itemnum1 = parseInt(item.num);
                     var rs1 = tx.executeSql('SELECT * FROM orderItemDB WHERE orderNO = ? AND name = ? AND cookbool = ?', [Global.orderNO,item.name,0]);
                     if (rs1.rows.length >0){
                         var item1 = rs1.rows.item(0);
                         var  itemnum2 = parseInt(item1.num);
                         var itemnum = itemnum1 + itemnum2;
                         tx.executeSql('UPDATE orderItemDB SET num = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [itemnum,Global.orderNO,item.name,1]);
                         tx.executeSql('DELETE FROM orderItemDB WHERE orderNO = ? AND name = ? AND cookbool = ?', [Global.orderNO,item.name,0]);
                     }
                     index++;
              }
              var rs2 = tx.executeSql('SELECT * FROM orderItemDB WHERE orderNO = ? AND cookbool = ?', [Global.orderNO,0]);
              index = 0;
               while (index< rs2.rows.length){
                   var item = rs2.rows.item(index);
                   tx.executeSql('UPDATE orderItemDB SET cookbool = ? WHERE orderNO = ? AND name = ? AND cookbool = ?', [1,Global.orderNO,item.name,0]);
                   index++;
               }
            } )
         }
}
