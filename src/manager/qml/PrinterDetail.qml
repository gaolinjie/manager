// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global
Item {
    id: pinterDetail
    width: 300
    height: 600
    x: 100

    Component.onCompleted: {
        pinterDetail.x = 0;
    }

    Behavior on x {
        NumberAnimation { duration: 500; easing.type: Easing.OutQuint}
    }

    Text {
        id: printerDetailTitle
        anchors.left: parent.left
        anchors.top: parent.top
        text: "打印机配置详情"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 30
        color: "white"
    }

    Text {
        id: choosePrinterTitle
        anchors.left: printerDetailTitle.left
        anchors.top: printerDetailTitle.bottom; anchors.topMargin: 30
        text: "网络中的打印机"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "white"
    }
/*
    Rectangle {
        id: choosePrinterRect
        width: 320; height: 36
        color: "#BABAB9"
        border.color: "#A3A5A0"//"#d54d34"
        border.width: 2
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTitle.bottom; anchors.topMargin: 15
    }  */

    ComboBox {
        id: selectPrinterDeviceComboBox
        prompt: "请选择网络中的打印机设备"
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTitle.bottom; anchors.topMargin: 15
        dropDown: true
        z: 3
        contentModel: printerDeviceModel
        onOperate: {
            saveData(index)
            update()
        }
        Connections{
            target: signalManager
            onPrinterChanged: { selectPrinterDeviceComboBox.update() }
        }
        ListModel {
            id: printerDeviceModel
            Component.onCompleted: getModel()
            function getModel()
            {
                printerDeviceModel.clear();
                var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
                db.transaction(
                    function(tx) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS printerActualListData(printerActualName TEXT)');
                            var rs = tx.executeSql('SELECT * FROM printerActualListData');
                            var index = 0;
                            while (index < rs.rows.length) {
                                var item = rs.rows.item(index);
                                printerDeviceModel.append({ "name": item.printerActualName });
                                index++;
                          }
                      }
                  )
            }
        }
        function saveData(index)
        {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerSelfActuaData(selfName TEXT, actualName TEXT,type TEXT)');
                    var rs = tx.executeSql('SELECT * FROM printerSelfActuaData WHERE selfName = ?',Global.printerSelfDefName);
                    if (rs.rows.length > 0)
                    {
                        tx.executeSql('UPDATE printerSelfActuaData SET actualName = ? WHERE selfName = ?',[printerDeviceModel.get(index).name,Global.printerSelfDefName]);
                    }
                    else
                    {
                        tx.executeSql('INSERT INTO printerSelfActuaData VALUES(?,?,?)', [Global.printerSelfDefName, printerDeviceModel.get(index).name, ""]);
                    }
                }
            )
        }
        function update()
        {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerSelfActuaData(selfName TEXT, actualName TEXT,type TEXT)');
                    var rs = tx.executeSql('SELECT * FROM printerSelfActuaData WHERE selfName = ?',Global.printerSelfDefName);
                    var index = 0;
                    if(rs.rows.length>0)
                    {
                        var item = rs.rows.item(0);
                        Global.printerActualName = item.actualName;
                    }
                    else Global.printerActualName = "";
                }
            )
            if(Global.printerActualName == "")
            {
                selectPrinterDeviceComboBox.prompt =  "请选择网络中的打印机设备";
            }
            else { selectPrinterDeviceComboBox.prompt = Global.printerActualName }
        }
    }

    Text {
        id: choosePrinterTypeTitle
        anchors.left: printerDetailTitle.left
        anchors.top: selectPrinterDeviceComboBox.bottom; anchors.topMargin: 30
        text: "打印机类型"
        font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
        color: "white"
    }

    ComboBox {
        id: selectPrinterTypeComboBox
        prompt: "请选择打印机类型"
        anchors.left: choosePrinterTitle.left
        anchors.top: choosePrinterTypeTitle.bottom; anchors.topMargin: 15
        dropDown: true
        z: 2
        contentModel: printerTypeModel
        onOperate: {
            saveData(index);
            update()
        }
        Connections{
            target: signalManager
            onPrinterChanged: { selectPrinterTypeComboBox.update() }
        }

        ListModel
        {
            id: printerTypeModel
            Component.onCompleted: getModel()
            function getModel()
            {
                 printerTypeModel.append({ "name": "前台打印机" });
                 printerTypeModel.append({ "name": "厨房打印机" });
                 printerTypeModel.append({ "name": "其它类型" });
            }
        }
        function saveData(index)
        {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerSelfActuaData(selfName TEXT, actualName TEXT,type TEXT)');
                    var rs = tx.executeSql('SELECT * FROM printerSelfActuaData WHERE selfName = ?',Global.printerSelfDefName);
                    if (rs.rows.length > 0)
                    {
                        tx.executeSql('UPDATE printerSelfActuaData SET type = ? WHERE selfName = ?',[printerTypeModel.get(index).name,Global.printerSelfDefName]);
                    }
                    else
                    {
                        tx.executeSql('INSERT INTO printerSelfActuaData VALUES(?,?,?)', [Global.printerSelfDefName, "", printerTypeModel.get(index).name]);
                    }
                }
            )
        }
        function update()
        {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS printerSelfActuaData(selfName TEXT, actualName TEXT,type TEXT)');
                    var rs = tx.executeSql('SELECT * FROM printerSelfActuaData WHERE selfName = ?',Global.printerSelfDefName);
                    var index = 0;
                    if(rs.rows.length>0)
                    {
                        var item = rs.rows.item(0);
                        if (item.type == "")selectPrinterTypeComboBox.prompt = "请选择打印机类型";
                        else { selectPrinterTypeComboBox.prompt = item.type }
                    }
                    else selectPrinterTypeComboBox.prompt = "请选择打印机类型";
                }
            )
        }
    }
}
