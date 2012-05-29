// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

Item {
    id: addPanel
    width: 400
    height: 800
    property int rectCid: -1
<<<<<<< HEAD

    Connections{
        target: start
        onClearEdit: {
            clearEdit();
        }
        onRefreshEdit: {
            refreshEdit();
        }
    }
=======
    property string rectTitle: ""
    property string rectBackColor: editRect.backColor
    property string rectFroeColor: editRect.backColor
>>>>>>> 056703b5dc6f6de5032c3610280c1ab111f24e9e

    states: [
        State {
            name: "view"
            PropertyChanges { target: addList; visible: true; x: 0 }
            PropertyChanges { target: editRect; visible: false; x: 100 }
        },

        State {
            name: "new"
            PropertyChanges { target: addList; visible: false; x: 100 }
            PropertyChanges { target: editRect; visible: true; x: 0}
        },

        State {
            name: "edit"
            PropertyChanges { target: addList; visible: false; x: 100 }
            PropertyChanges { target: editRect; visible: true; x: 0}
        }
    ]

    Rectangle {
        id: panel
        width: parent.width
        height: parent.height
        color: "#de9317"
        z: 2

        Image {
            id: nextButton
            anchors.left: title.right; anchors.leftMargin: 205
            anchors.bottom: title.bottom; anchors.bottomMargin: 5
            sourceSize.width: 36; sourceSize.height: 36
            source: "qrc:/images/next.png"

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    addPanel.x = 1280
                }
            }
        }

        Text {
            id: title
            x: 40; y: 40
            text: "新 建"
            font.pixelSize: 38
            color: "white"
        }

        AddList {
            id: addList
            anchors.top: title.bottom
            anchors.topMargin: 30

            Behavior on x {
                NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
            }
        }

        Item {
            id: editRect
            width: 400
            height:700
            anchors.top: addList.top
            visible: false
            x: 100

            property string backColor: ""
            property string name: ""
            property string image: ""

            Behavior on x {
                NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
            }

            Rectangle {
                id: wraper
                width: 324; height: 60
                color: "#d54d34"
                x: 40
                opacity: 0.8
                smooth: true

                Rectangle {
                    id: rect
                    width: 44
                    height: 44
                    x: 12
                    color: editRect.backColor
                    anchors.verticalCenter: parent.verticalCenter
                    radius: 1
                    Image {
                        id: itemImage
                        source: editRect.image
                        sourceSize.width: 42
                        sourceSize.height: 42
                        anchors.centerIn: parent
                    }
                }

                Text {
                    id: nameText
                    text: editRect.name
                    anchors.left: rect.right; anchors.leftMargin: 20
                    anchors.top: rect.top
                    font.pixelSize: 30
                    color: "white"
                }
            }

            Text {
                id: nameTitle
                text: "菜单名称:"
                anchors.left: wraper.left
                anchors.top: wraper.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            Rectangle {
                id: nameEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: wraper.left
                anchors.top: nameTitle.bottom; anchors.topMargin: 15
                clip: true


                TextEdit {
                    id: nameTextEdit
                    width: 300
                    text: addPanel.rectTitle
                    font.pixelSize: 20
                    color: "white"
                    focus: true
                    anchors.centerIn: parent
                    clip: true
                }
            }

            Text {
                id: backTitle
                text: "背景颜色:"
                anchors.left: wraper.left
                anchors.top: nameEdit.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            ColorPicker {
                id: backEdit
                width: 320; height: 36
                color: "#de9317"
                anchors.left: wraper.left
                anchors.top: backTitle.bottom; anchors.topMargin: 15
                z: 2
            }

            Text {
                id: foreTitle
                text: "前景颜色:"
                anchors.left: wraper.left
                anchors.top: backEdit.bottom; anchors.topMargin: 40
                font.pixelSize: 16
                color: "white"
            }

            ColorPicker {
                id: foreEdit
                width: 320; height: 36
                color: "#de9317"
                anchors.left: wraper.left
                anchors.top: foreTitle.bottom; anchors.topMargin: 15
                z: 1
            }

            Rectangle {
                id: okButton
                anchors.left: wraper.left; anchors.leftMargin: 10
                anchors.bottom: parent.bottom; anchors.bottomMargin: 70
                width: 140; height: 27
                color: "#de9317"
                border.color: "white"
                border.width: 2

                Text {
                    text: "确 定"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        okButton.color = "#d54d34"
                    }
                    onClicked: {
                        if (nameTextEdit.text == "" || backEdit.color == foreEdit.color) {

                        }
                        else {
                            if (addPanel.state == "new") {
                                var index = grid.model.count - 1;
<<<<<<< HEAD
                                var maxcid = -1;
                                if (grid.model.count > 1) {
                                    maxcid = grid.model.get(index-1).cid + 1;
                                }
                                else {
                                    maxcid = 0;
                                }
                                grid.model.insert(index, {"cid": maxcid, "title": nameTextEdit.text, "image": "", "style": "IMAGE_RECT", "slotQml": "qrc:/qml/manager.qml", "backColor": backEdit.color, "foreColor": foreEdit.color});
=======
                                var maxcid = grid.model.get(index-1).cid + 1;
                                grid.model.insert(index, {"cid": maxcid, "title": nameTextEdit.text, "image": "", "style": "IMAGE_RECT", "slotQml": "", "backColor": backEdit.color, "foreColor": foreEdit.color});
>>>>>>> 056703b5dc6f6de5032c3610280c1ab111f24e9e
                            }
                            else if (addPanel.state == "edit") {
                                var index = 0;
                                while (index < grid.model.count) {
                                    if (grid.model.get(index).cid == addPanel.rectCid) {
                                        grid.model.get(index).title = nameTextEdit.text;
                                        grid.model.get(index).backColor = backEdit.color;
                                        grid.model.get(index).foreColor = foreEdit.color;
                                        break;
                                    }
                                    index++;
                                }
                            }
                            addPanel.x = 1280;
                            clearEdit();
                        }
                    }
                    onReleased: {
                        okButton.color = "#de9317"
                    }
                }
            }

            Rectangle {
                id: cancelButton
                anchors.left: okButton.right; anchors.leftMargin: 20
                anchors.bottom: okButton.bottom
                width: 140; height: 27
                color: "#de9317"
                border.color: "white"
                border.width: 2

                Text {
                    text: "取 消"
                    anchors.centerIn: parent
                    color: "white"
                    font.pixelSize: 16
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        cancelButton.color = "#d54d34"
                    }
                    onClicked: {
                        clearEdit();
                        addPanel.state = "view"
                    }
                    onReleased: {
                        cancelButton.color = "#de9317"
                    }
                }
            }
        }
    }

    function clearEdit() {
        nameTextEdit.text = '';
        backEdit.color = "#de9317";
        foreEdit.color = "#de9317";
    }

    function refreshEdit() {
        nameTextEdit.text = Global.checkedTitle;
        backEdit.color = Global.checkedBackColor;
        foreEdit.color = Global.checkedForeColor;
    }

    BorderImage {
        anchors.fill: panel
        anchors { leftMargin: -9; topMargin: -6; rightMargin: -8; bottomMargin: -8 }
        border { left: 10; top: 10; right: 10; bottom: 10 }
        source: "qrc:/images/shadow.png";
        smooth: true
        z: 1
    }
}
