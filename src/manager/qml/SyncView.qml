import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: itemsScreen
    width: 1280; height: 800
    signal loadStart()

    Connections{
        target: syncManager
        onNeedSync: {
            syncWarnningText.visible = true;
        }
        onHaveSynced: {
            dialogContent.text = "同步菜单数据完成"
            returnButton.visible = true;
            busyIndicator.visible = false;
        }
    }

    Image {
        id: background
        source: "qrc:/images/background.png"
    }

    Timer {
        id: timer
        interval: 350
        running: false
        onTriggered: {
            loadStart()
        }
    }

    Rectangle {
        id: mainView
        width: parent.width; height: parent.height
        color: "#9061C2"
        anchors.verticalCenter: parent.verticalCenter
        transform: Rotation { id: viewRotation; origin.x: parent.width * 0.8; origin.y: parent.height * 0.8 * 0.5 + 100; axis { x: 0; y: 1; z: 0 } angle: -70 }
        smooth: true
        property string state: "back"

        Text {
            id: viewTitle
            anchors.left: parent.left; anchors.top: parent.top
            anchors.leftMargin: 125; anchors.topMargin: 70
            text: Global.type
            font.pixelSize: 50
            color: "white"
            font.family: "微软雅黑"
            smooth: true
        }

        Image {
            id: backButton
            source: "qrc:/images/back.png"
            anchors.right: viewTitle.left; anchors.rightMargin: 46
            anchors.verticalCenter: viewTitle.verticalCenter

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    mainView.state = "gone"
                    timer.running = true
                }
            }
        }

        Rectangle {
            id: syncAllRect
            width: 400; height: 100
            color: "#de9317"
            anchors.left: viewTitle.left; anchors.leftMargin: 5
            anchors.top: viewTitle.bottom; anchors.topMargin: 100

            Image {
                id: syncAllImage
                source: "qrc:/images/refresh.png"
                sourceSize.width: 64
                sourceSize.height: 64
                anchors.verticalCenter: parent.verticalCenter
                x: 50
            }

            Text {
                id: syncAllText
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: syncAllImage.right
                anchors.leftMargin: 20
                font.pixelSize: 30
                color: "white"
                text: "同步所有数据"
                font.family: "微软雅黑"
                font.letterSpacing: 2
                smooth: true
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    syncAllRect.color = "#d54d34"
                }
                onClicked: {
                    foreground.visible = true;
                    dialog.visible = true;
                    dialog.y = 275;
                    dialogContent.text = "同步所有数据";
                }
                onReleased: {
                    syncAllRect.color = "#de9317"
                }
            }
        }

        Text {
            id: syncWarnningText
            anchors.bottom: viewTitle.bottom
            anchors.bottomMargin: 4
            anchors.left: viewTitle.right
            anchors.leftMargin: 20
            font.pixelSize: 16
            color: "red"
            text: "警告： 系统中仍有设备数据未更新，请先同步所有设备数据！"
            font.family: "微软雅黑"
            font.letterSpacing: 1
            smooth: true
            visible: false

            Component.onCompleted: {
                if (syncManager.isNeedSync()) {
                    syncWarnningText.visible = true;
                }
                else {
                    syncWarnningText.visible = false;
                }
            }
        }

        Rectangle {
            id: foreground
            width: 1280; height: 800
            anchors.centerIn: parent
            color: "black"
            opacity: 0.7
            visible: false
        }

        Rectangle {
            id: dialog
            y: 800
            width: 1280; height: 250
            color: "#d54d34"
            visible: false

            Behavior on y {
                NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
            }

            Text {
                id: dialogContent
                text: ""
                color: "white"
                font.pixelSize: 28
                font.family: "微软雅黑"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top; anchors.topMargin: 70
            }

            BusyIndicator {
                id: busyIndicator
                anchors.horizontalCenter: dialogContent.horizontalCenter
                anchors.top: dialogContent.bottom; anchors.topMargin: 40
                visible: false
            }

            Rectangle {
                id: okButton
                anchors.right: parent.horizontalCenter; anchors.rightMargin: 20
                anchors.bottom: parent.bottom; anchors.bottomMargin: 70
                width: 79; height: 27
                color: "#d54d34"
                border.color: "white"
                border.width: 2

                Text {
                    text: "确 定"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.family: "微软雅黑"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        okButton.color = "#DE4209"
                    }
                    onClicked: {
                        //dialog.y = 800;
                        //foreground.visible = false;
                        //client.syncMenu("192.168.1.106");
                        syncManager.syncMenu();
                        okButton.visible = false;
                        cancelButton.visible = false;
                        busyIndicator.visible = true;
                        dialogContent.text = "正在同步菜单数据, 请稍候...";
                    }
                    onReleased: {
                        okButton.color = "#d54d34"
                    }
                }
            }

            Rectangle {
                id: cancelButton
                anchors.left: parent.horizontalCenter; anchors.leftMargin: 20
                anchors.bottom: parent.bottom; anchors.bottomMargin: 70
                width: 79; height: 27
                color: "#d54d34"
                border.color: "white"
                border.width: 2

                Text {
                    text: "取 消"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.family: "微软雅黑"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        cancelButton.color = "#DE4209"
                    }
                    onClicked: {
                        dialog.y = 800;
                        foreground.visible = false;
                    }
                    onReleased: {
                        cancelButton.color = "#d54d34"
                    }
                }
            }

            Rectangle {
                id: returnButton
                anchors.horizontalCenter: dialogContent.horizontalCenter
                anchors.bottom: parent.bottom; anchors.bottomMargin: 70
                width: 79; height: 27
                color: "#d54d34"
                border.color: "white"
                border.width: 2
                visible: false

                Text {
                    text: "返 回"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                    font.family: "微软雅黑"
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        cancelButton.color = "#DE4209"
                    }
                    onClicked: {
                        dialog.y = 800;
                        foreground.visible = false;
                    }
                    onReleased: {
                        cancelButton.color = "#d54d34"
                    }
                }
            }
        }

        states: [
            State {
                name: "back"
                PropertyChanges { target: viewRotation; angle: 0; origin.x: parent.width; origin.y: parent.height * 0.5 +100}
                PropertyChanges { target: mainView; x: 0}
                when: mainView.state == "back"
            },

            State {
                name: "gone"
                PropertyChanges { target: mainView; x: -1024}
                PropertyChanges { target: viewRotation; angle: 0}
                when: mainView.state == "gone"
            }
        ]

        transitions: [
            Transition {
                from: ''; to: 'back'
                NumberAnimation { target: viewRotation; property: "angle"; duration: 500; easing.type: 'OutExpo'}
                NumberAnimation { target: mainView; properties: 'width, height'; duration: 500; easing.type: 'OutExpo'}
            },

            Transition {
                from: 'back'; to: 'gone'
                SequentialAnimation {
                         NumberAnimation { target: mainView; properties: 'width, height'; duration: 200}
                         NumberAnimation { target: mainView; properties: 'x'; duration: 200}
                }
            }
        ]
    }
}
