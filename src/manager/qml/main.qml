import QtQuick 1.0

Item {
    id: screen
    width: 1280; height: 800

    Component.onCompleted: {
        var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
    }

    Loader {
        id: mainLoader
        source: "qrc:/qml/manager.qml"
        anchors.centerIn: parent
    }

    Connections{
        target: mainLoader.item
        onLoadStart: {mainLoader.source = "qrc:/qml/manager.qml"}
        onLoadRect: {mainLoader.source = qmlFile}
        onLoadLogin: {mainLoader.source = "qrc:/qml/login.qml"}
        onLoadCashier: {mainLoader.source = "qrc:/qml/cashier.qml"}
    }
}
