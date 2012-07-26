import QtQuick 1.0
import "../js/global.js" as Global

Rectangle {
    id: rect
    width: parent.width
    height: parent.height
    color: backColor
    smooth: true

    property string iconSource: ""
    property string iconTitle: ""

    transform: Rotation {
        id: rotation;
        origin.x: parent.width * 0.5;
        origin.y: 0//parent.height * 0.5;
        axis { x: 1; y: 0; z: 0 }
        angle: 0
    }

    MouseArea{
        anchors.fill: parent
        onPressed: {
            rotation.angle = -15;
        }
        onClicked: {
            Global.backColor = backColor
            Global.foreColor = foreColor
            Global.title = title
            loadRect(slotQml)
        }
        onReleased: {
            rotation.angle = 0;
        }
    }

    Image {
        id: icon
        x: 50
        anchors.verticalCenter: parent.verticalCenter
        source: parent.iconSource
        sourceSize.width: 90
        sourceSize.height: 90

        property bool on: false
        NumberAnimation on rotation {
            running: icon.on; from: 0; to: 360; loops: Animation.Infinite; duration: 1200
        }

        Component.onCompleted: {
            if (parent.iconTitle == "同 步") {
                isNeedSync()
            }
        }

        function isNeedSync() {
            var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
            db.transaction(
                function(tx) {
                    tx.executeSql('CREATE TABLE IF NOT EXISTS deviceDB(mac TEXT key, ip TEXT, deviceNO INTEGER, synced INTEGER)');
                            var rs = tx.executeSql('SELECT * FROM deviceDB WHERE synced = ?', [0]);
                    if (rs.rows.length > 0) {
                        icon.source = "qrc:/images/refresh-warning.png";
                        icon.on = true;
                    }
                    else {
                        icon.source = "qrc:/images/refresh.png";
                        icon.on = false;
                    }
                })
        }
    }

    Text {
        id: text
        x: 150
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: 20
        text: parent.iconTitle
        font.pixelSize: 30
        font.family: "微软雅黑"
        color: "white"
        smooth: true
    }

    Connections{
        target: syncManager
        onNeedSync: {
            if (text.text == "同 步") {
                icon.source = "qrc:/images/refresh-warning.png";
                icon.on = true;
            }
        }
    }
}
