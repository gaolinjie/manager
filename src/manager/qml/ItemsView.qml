import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: itemsScreen
    width: 1280
    height: 800
    signal loadStart
    signal loadRect(string qmlFile)
    signal clearEdit()
    signal refreshEdit()
    clip: true
    Component.onCompleted: {
        timer2.running = true;
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
            loadRect("MenuView.qml")
        }
    }

    Timer {
        id: timer2
        interval: 350
        running: false
        onTriggered: {
            addPanel.visible = true;
        }
    }

    Rectangle {
        id: itemsView
        width: parent.width; height: parent.height
        color: Global.backColor
        anchors.verticalCenter: parent.verticalCenter
        transform: Rotation { id: viewRotation; origin.x: parent.width * 0.8; origin.y: parent.height * 0.8 * 0.5 + 100; axis { x: 0; y: 1; z: 0 } angle: -70 }
        smooth: true
        property string state: "back"

        Text {
            id: viewTitle
            anchors.left: parent.left; anchors.top: parent.top
            anchors.leftMargin: 100; anchors.topMargin: 70
            text: Global.title
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 50
            color: "white"
        }

        Image {
            id: backButton
            anchors.right: viewTitle.left; anchors.rightMargin: 21
            anchors.verticalCenter: viewTitle.verticalCenter
            sourceSize.width: 50; sourceSize.height: 50
            source: "qrc:/images/back.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addPanel.visible = false;
                    itemsView.state = "gone"
                    timer.running = true
                }
            }
        }

        Flickable {
             id: flick
             width: 1180; height: 384
             contentWidth: (grid.count/3+1)*grid.cellWidth; contentHeight: 384
             x:100; y:201

             ItemGrid {
                 id: grid
                 x:450; //y:201

                 Behavior on x {
                     NumberAnimation {duration: 1600; easing.type: Easing.OutQuint}
                 }

                 Component.onCompleted: {
                     //timer.running = true
                     grid.x = 0
                 }
             }

             Behavior on contentX {
                 NumberAnimation { duration: 1000; easing.type: Easing.OutQuint }
             }
        }

        AddItemPanel {
            id: addPanel
            x: parent.width//parent.width - addPanel.width
            visible: false
            Behavior on x {
                NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
            }
        }

        Loader {
            id: imageManagerLoader
            anchors.left: parent.left
            anchors.top: parent.top
            source: ""
            z: 3
        }

        Rectangle {
            id: bottomBar
            width: 1280; height: 100
            color: "#086db8"
            y: 800
            visible: false

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
                        addPanel.rectIid = Global.checkedIid;
                        refreshEdit();
                        addPanel.state = "edit";
                        addPanel.visible = true;
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
                        while (index < grid.model.count) {
                            if (grid.checkedIndex == grid.model.get(index).iid) {
                                grid.model.remove(index);
                                break;
                            }
                            index++;
                        }

                        bottomBar.y = 800;
                        addPanel.x = 1280;
                        clearEdit();
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
                        grid.pressAndHoldRect(-1);
                        bottomBar.y = 800;
                        addPanel.x = 1280;  
                        clearEdit();
                    }
                }
            }
        }


        states: [
            State {
                name: "back"
                PropertyChanges { target: viewRotation; angle: 0; origin.x: itemsView.width; origin.y: itemsView.height * 0.5 +100}
                PropertyChanges { target: itemsView; x: 0}
                when: itemsView.state == "back"
            },

            State {
                name: "gone"
                PropertyChanges { target: viewRotation; angle: 0}
                PropertyChanges { target: itemsView; x: -1024}
                when: itemsView.state == "gone"
            }
        ]

        transitions: [
            Transition {
                from: ''; to: 'back'
                NumberAnimation { target: viewRotation; property: "angle"; duration: 500; easing.type: 'OutExpo'}
                NumberAnimation { target: itemsView; properties: 'width, height'; duration: 500; easing.type: 'OutExpo'}
            },

            Transition {
                from: 'back'; to: 'gone'
                SequentialAnimation {
                         NumberAnimation { target: itemsView; properties: 'width, height'; duration: 200}
                         NumberAnimation { target: itemsView; properties: 'x'; duration: 200}
                }
            }
        ]
    }
}
