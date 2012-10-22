import QtQuick 1.0
import "../js/global.js" as Global

ListView {
    id: ordersList
    width: 800; height:250
    model: ordersModel
    delegate: orderDelegate
    smooth: true
    signal orderItemUpdateSignal()

    Connections {
        target: parent.parent
        onMainOrderListUpdateSignal: {
            updateOrderList()//更新总价格
        }
    }

    ListModel{
        id: ordersModel
    }

    Component {
        id: orderDelegate

        Item {
            id: wraper
            width: 600; height: 30
            Component.onCompleted: {
                sumText.text = wraper.ListView.view.model.get(0).total
                discText.text = wraper.ListView.view.model.get(0).discount
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    wraper.ListView.view.currentIndex = index
                    Global.orderNO = orderNO
                    //console.log(Global.orderNO);
                    Global.gorderIndex =index
                    sumText.text = total
                    discText.text = discount

                    wraper.ListView.view.itemUpdate()
                }
            }

            Rectangle {
                id: orderRect
                width: 700; height: 30
                radius: 8
                anchors.left: parent.left; anchors.leftMargin: 40
                anchors.verticalCenter: parent.verticalCenter
                color: wraper.ListView.isCurrentItem ? "#f4a83d" : "white"
                smooth: true
                border.color: "grey"
                border.width: 1

                Text {
                    id: orderNOText
                    text: orderNO
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 10
                    color: "black"
                }

                Text {
                    id: seatText
                    text: seat
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 140
                    color: "black"
                }

                Text {
                    id: dateText
                    text: date
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 272
                    color: "black"
                }

                Text {
                    id: timeText
                    text: time
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 400
                    color: "black"
                }

                Text {
                    id: discountText
                    text: discount
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 534
                    color: "black"
                }


                Text {
                    id: totalText
                    text: total
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 15
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left; anchors.leftMargin: 664
                    color: "black"
                }
            }

            Image {
                source: "qrc:/images/minus2.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: orderRect.left; anchors.rightMargin: 7
                visible: wraper.ListView.isCurrentItem
                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                         //wraper.ListView.view.model.remove(index)
                        wraper.ListView.view.minusorderListData()
                        wraper.ListView.view.loadOrderList()
                        wraper.ListView.view.currentIndex =Global.gorderIndex;
                    }
                }
            }

            Image {
                id: next
                source: "qrc:/images/next2.png"
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: orderRect.right; anchors.leftMargin: -10
                visible: wraper.ListView.isCurrentItem
            }
        }
    }


    function loadOrderList() {
            ordersModel.clear();
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS orderListDB(oid TEXT key, orderNO INTEGER, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)');
                    var rs = tx.executeSql('SELECT * FROM orderListDB WHERE pay = ?', [Global.pay]);
                    var index = 0;
                    if (rs.rows.length > 0) {
                        while (index < rs.rows.length) {
                            var item = rs.rows.item(index);
                            if (index == 0) {
                                Global.oid = item.oid
                            }
                            ordersModel.append({"oid": item.oid,
                                                "orderNO": item.orderNO,
                                                "seat": item.seat,
                                                "mac": item.mac,
                                                "date": item.date,
                                                "time": item.time,
                                                "discount": item.discount,
                                                "total": item.total,
                                                "pay": item.pay});

                            index++;
                        }
                    } else {
                       Global.orderNO = 0;
                    }
                }
            )
            orderItemUpdateSignal();
       }

      function saveOrderList() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('DROP TABLE orderListDB');
                    tx.executeSql('CREATE TABLE IF NOT EXISTS orderListDB(oid TEXT key, orderNO INTEGER, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)');
                    var index = 0;
                    while (index < ordersModel.count) {
                        var item = ordersModel.get(index);
                        tx.executeSql('INSERT INTO orderListDB VALUES(?,?,?,?,?,?,?,?,?)', [item.oid, item.orderNO, item.seat, item.mac, item.date, item.time, item.discount, item.total, item.pay]);
                        index++;
                    }
                }
            )
       }

      function updateOrderList(){
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        ordersModel.setProperty(Global.gorderIndex,"total",Global.gorderTotalPrice);
        sumText.text = Global.gorderTotalPrice.toString()

        db.transaction(
            function(tx) {
                    tx.executeSql('UPDATE orderListDB SET total = ? WHERE orderNO = ? ', [Global.gorderTotalPrice,Global.orderNO]);
                }
          )
      }

    function itemUpdate() {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
        db.transaction(
            function(tx) {
                //tx.executeSql('DROP TABLE orderItemDB');
                tx.executeSql('CREATE TABLE IF NOT EXISTS orderItemDB(oid TEXT key, iid TEXT, tid TEXT, type TEXT, name TEXT, image TEXT, price REAL, print INTEGER, printer TEXT, num INTEGER)');
                var rs = tx.executeSql('SELECT * FROM orderItemDB WHERE oid = ?', [Global.oid]);
                var index = 0;
                Global.gorderTotalPrice = 0;
                if (rs.rows.length > 0) {
                    while (index < rs.rows.length) {
                        var item = rs.rows.item(index);
                        var tempPrice = item.price;
                        var tempNum = item.num;
                        Global.gorderTotalPrice += (tempPrice*tempNum);
                        index++;
                    }
                 }
              }
            )
         updateOrderList();
         orderItemUpdateSignal();
     }

    function minusorderListData(){
         var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
         ordersModel.remove(Global.gorderIndex);
          db.transaction(
                 function(tx) {
                  tx.executeSql('CREATE TABLE IF NOT EXISTS orderListDB(orderNO INTEGER key, seat TEXT, mac TEXT, date DATE, time TIME, discount REAL, total REAL, pay INTEGER)');
                  var rs = tx.executeSql('SELECT * FROM orderListDB WHERE pay = ?', [Global.pay]);
                  var index = 0;
                  if (rs.rows.length > 0) {
                      while (index < rs.rows.length) {
                          var item = rs.rows.item(index);
                          if (Global.orderNO!=item.orderNO) {
                              Global.oldorderNO = item.orderNO;
                             index++;
                           }
                          else {
                              break;
                           }
                       }
                  }
                  tx.executeSql('DELETE FROM orderListDB WHERE orderNO = ? ', [Global.orderNO]);
                  tx.executeSql('DELETE FROM orderItemDB WHERE orderNO = ? ', [Global.orderNO]);
                  if (index ==0){Global.oldorderNO =""; }
                  else {Global.orderNO=Global.oldorderNO;}
              }
          )
        Global.gorderIndex--;
         }
    function finalorderListIndexNO(){
        Global.gorderIndex = ordersModel.count -1
        var index =0
        while (index < ordersModel.count){
            if (index == ordersModel.count-1 ){Global.orderNO = ordersModel.get(index).orderNO}
            index++
        }
    }
    function updateText(){
        if (ordersModel.count>0)
          {
             sumText.text = ordersModel.get(Global.gorderIndex).total
             discText.text = ordersModel.get(Global.gorderIndex).discount
          }
        else
          {
             sumText.text = 0;
             discText.text = 0;
          }
    }
}
