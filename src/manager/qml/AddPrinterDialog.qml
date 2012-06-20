// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

Rectangle {
    id: dialog
    y: 800
    width: 1280; height: 250
    color: "#7B3349"
    visible: false

    property string content: ""

    signal ok
    signal cancel

    Behavior on y {
        NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
    }

    Text {
        id: dialogContent
        text: "添加打印机"
        color: "white"
        font.pixelSize: 28
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.top: parent.top; anchors.topMargin: 40
    }

    Text {
        id: nameTitle
        text: "名 称:"
        anchors.left: nameEdit.left
        anchors.bottom: nameEdit.top; anchors.bottomMargin: 10
        font.pixelSize: 16
        color: "white"
    }

    Rectangle {
        id: nameEdit
        width: 320; height: 36
        color: "#7B3349"
        border.color: "white"//"#d54d34"
        border.width: 2
        anchors.horizontalCenter: dialogContent.horizontalCenter
        anchors.top: dialogContent.bottom; anchors.topMargin: 50
        clip: true


        TextEdit {
            id: nameTextEdit
            width: 300
            text: ""
            font.pixelSize: 20
            color: "white"
            focus: true
            anchors.centerIn: parent
            clip: true
        }
    }

    Rectangle {
        id: okButton
        anchors.right: parent.horizontalCenter; anchors.rightMargin: 20
        anchors.bottom: parent.bottom; anchors.bottomMargin: 30
        width: 79; height: 27
        color: "#7B3349"
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
                okButton.color = "#DE4209"
            }
            onClicked: {
                dialog.y = 800;
                foreground.visible = false;

                if (nameTextEdit.text == "") {

                }
                else {
                    var index = printerGrid.model.count - 1;
                    var maxcid = -1;
                    if (printerGrid.model.count > 1) {
                        maxcid = printerGrid.model.get(index-1).cid + 1;
                    }
                    else {
                        maxcid = 0;
                    }
                    printerGrid.model.insert(index, {"pid": maxcid, "name": nameTextEdit.text, "active": 0, "style": "PRINTER_RECT"});
                }

            }
            onReleased: {
                okButton.color = "#7B3349"
            }
        }
    }

    Rectangle {
        id: cancelButton
        anchors.left: parent.horizontalCenter; anchors.leftMargin: 20
        anchors.bottom: parent.bottom; anchors.bottomMargin: 30
        width: 79; height: 27
        color: "#7B3349"
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
                cancelButton.color = "#DE4209"
            }
            onClicked: {
                dialog.y = 800;
                foreground.visible = false;
            }
            onReleased: {
                cancelButton.color = "#7B3349"
            }
        }
    }
}
