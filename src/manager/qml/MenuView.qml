import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: menuView
    width: 1280; height: 800
    clip: true

    signal loadRect(string qmlFile)
    signal clearEdit()
    signal refreshEdit()

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/images/background.png"
    }

    Image {
        id: backButton
        anchors.right: title.left; anchors.rightMargin: 20
        anchors.bottom: title.bottom; anchors.bottomMargin: 7
        source: "qrc:/images/back.png"

        MouseArea {
            anchors.fill: parent
            onClicked: {
                loadRect("qrc:/qml/ManagerView.qml")
            }
        }
    }

    Text {
        id: title
        x: 130; y: 70
        text: "菜 单"
        font.family: "微软雅黑"
        font.pixelSize: 50
        color: "white"
        opacity: 0
        smooth: true

        Behavior on x {
            NumberAnimation {duration: 1000; easing.type: Easing.OutQuint}
        }
        Behavior on opacity {
            NumberAnimation {duration: 1000; easing.type: Easing.OutQuint}
        }
    }

    Timer {
        id: timer
        interval: 1000; running: false; repeat: true
        onTriggered: {
            title.x = 100
            title.opacity = 1
        }
    }

    Flickable {
         id: flick
         width: 1180; height: 480
         contentWidth: (menuGrid.count/3+1)*menuGrid.cellWidth; contentHeight: 480
         x:100; y:201

         MenuGrid {
             id: menuGrid
             x:450; //y:201

             Behavior on x {
                 NumberAnimation {duration: 1600; easing.type: Easing.OutQuint}
             }

             Component.onCompleted: {
                 timer.running = true
                 menuGrid.x = 0
             }
         }

         Behavior on contentX {
             NumberAnimation { duration: 1000; easing.type: Easing.OutQuint }
         }
     }

    Rectangle {
        id: bottomBar
        width: 1280; height: 100
        color: "#086db8"
        y: 800


        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint }
        }

        Image {
            id: editButton
            source: "qrc:/images/edit.png"
            x: 80
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -10

            Text {
                id: editTitle
                text: "编 辑"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
                anchors.top: editButton.bottom; anchors.topMargin: 5
                anchors.horizontalCenter: editButton.horizontalCenter
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addPanel.rectTid = Global.checkedTid;
                    refreshEdit();
                    addPanel.state = "edit";
                    addPanel.x = 880;
                }
            }
        }

        Image {
            id: deleteButton
            source: "qrc:/images/delete.png"
            anchors.top: editButton.top
            anchors.left: editButton.right; anchors.leftMargin: 80

            Text {
                id: deleteTitle
                text: "删 除"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
                anchors.top: deleteButton.bottom; anchors.topMargin: 5
                anchors.horizontalCenter: deleteButton.horizontalCenter
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    var index = 0;
                    while (index < menuGrid.model.count) {
                        if (menuGrid.checkedIndex == menuGrid.model.get(index).tid) {
                            menuGrid.model.remove(index);
                            deleteItemsData(menuGrid.checkedIndex);
                            break;
                        }
                        index++;
                    }

                    bottomBar.y = 800;
                    addPanel.x = 1280;
                    clearEdit();
                    syncManager.setSyncOn();
                }

                function deleteItemsData(tidDeleted) {
                    var db = openDatabaseSync("DemoDB", "1.0", "Demo Model SQL", 50000);
                    db.transaction(
                        function(tx) {
                            tx.executeSql('CREATE TABLE IF NOT EXISTS menuItemDB(iid TEXT primary key, tid TEXT, type TEXT, name TEXT, image TEXT, detail TEXT, price REAL, print INTEGER, printer TEXT)');
                            tx.executeSql('DELETE FROM menuItemDB WHERE tid = ? ', [tidDeleted]);
                        }
                    )
                }
            }
        }

        Image {
            id: downButton
            source: "qrc:/images/down.png"
            anchors.top: deleteButton.top
            anchors.left: deleteButton.right; anchors.leftMargin: 80          

            Text {
                id: downTitle
                text: "返 回"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
                anchors.top: downButton.bottom; anchors.topMargin: 5
                anchors.horizontalCenter: downButton.horizontalCenter
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    menuGrid.pressAndHoldRect(-1);
                    bottomBar.y = 800;
                    addPanel.x = 1280;
                    clearEdit();
                }
            }
        }
    }

    AddPanel {
        id: addPanel
        x: parent.width//parent.width - addPanel.width
        Behavior on x {
            NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
        }
    }
}
