// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

Item {
    id: addPanel
    width: 400
    height: 800
    property string rectIid: ""
    property string addedImageName: ""
    property string addedImage: ""
    property string imagePreviewState: "hide"
    z: 2

    Connections{
        target: itemsScreen
        onClearEdit: {
            clearEdit();
        }
        onRefreshEdit: {
            refreshEdit();
        }
    }

    states: [
        State {
            name: "view"
            PropertyChanges { target: title; text: "新 建" }
        },

        State {
            name: "edit"
            PropertyChanges { target: title; text: "编 辑" }
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
            font.family: "微软雅黑"
            smooth: true
            color: "white"
        }

        Item {
            id: editRect
            width: 400
            height:700
            anchors.top: title.bottom; anchors.topMargin: 40
            anchors.left: title.left           

            property string backColor: ""
            property string name: ""
            property string image: ""

            Behavior on x {
                NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
            }


            Text {
                id: nameTitle
                text: "菜品名称:"
                anchors.left: editRect.left
                anchors.top: editRect.top// anchors.topMargin: 1540
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }

            Rectangle {
                id: nameEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: nameTitle.left
                anchors.top: nameTitle.bottom; anchors.topMargin: 15
                clip: true

                TextEdit {
                    id: nameTextEdit
                    width: 300
                    text: ""
                    font.pixelSize: 20
                    color: "white"
                    font.family: "微软雅黑"
                    smooth: true
                    focus: true
                    anchors.centerIn: parent
                    clip: true
                }
            }

            Text {
                id: priceTitle
                text: "菜品价格:"
                anchors.left: nameEdit.left
                anchors.top: nameEdit.bottom; anchors.topMargin: 30
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }

            Rectangle {
                id: priceEdit
                width: 320; height: 36
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: priceTitle.left
                anchors.top: priceTitle.bottom; anchors.topMargin: 15
                z: 2

                TextEdit {
                    id: priceTextEdit
                    width: 300
                    text: ""
                    font.pixelSize: 20
                    font.family: "微软雅黑"
                    smooth: true
                    color: "white"
                    focus: true
                    anchors.centerIn: parent
                    clip: true
                }

                Text {
                    id: priceUnit
                    text: "元/例"
                    anchors.right: priceEdit.right; anchors.rightMargin: 10
                    anchors.verticalCenter: priceTextEdit.verticalCenter
                    font.pixelSize: 16
                    font.family: "微软雅黑"
                    smooth: true
                    color: "white"
                }
            }

            Text {
                id: detailTitle
                text: "菜品介绍:"
                anchors.left: priceEdit.left
                anchors.top: priceEdit.bottom; anchors.topMargin: 30
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }

            Rectangle {
                id: detailEdit
                width: 320; height: 36*2
                color: "#de9317"
                border.color: "white"//"#d54d34"
                border.width: 2
                anchors.left: nameTitle.left
                anchors.top: detailTitle.bottom; anchors.topMargin: 15
                clip: true


                TextEdit {
                    id: detailTextEdit
                    width: 300; height: 36*2 - 20
                    text: ""
                    font.pixelSize: 20
                    font.family: "微软雅黑"
                    smooth: true
                    color: "white"
                    focus: true
                    anchors.centerIn: parent
                    clip: true
                }
            }

            Text {
                id: imageTitle
                text: "菜品图片:"
                anchors.left: detailEdit.left
                anchors.top: detailEdit.bottom; anchors.topMargin: 30
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }

            Rectangle {
                id: imageRect
                width: 320; height: 90
                color: "#d54d34"
                opacity: 0
                anchors.left: imageTitle.left
                y: imageTitle.y + imageTitle.height - imageRect.height

                Behavior on y {
                    NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
                }

                Behavior on opacity {
                    NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
                }
            }

            Image {
                id: imagePreview
                source: addPanel.addedImage
                sourceSize.width: 98; sourceSize.height: 72
                anchors.left: imageRect.left; anchors.leftMargin: 15
                anchors.verticalCenter: imageRect.verticalCenter
                opacity: 0

                Behavior on opacity {
                    NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
                }
            }

            Text {
                id: imagePreviewName
                text: addPanel.addedImageName
                anchors.left: imagePreview.right; anchors.leftMargin: 15
                anchors.top: imagePreview.top; //anchors.topMargin: 40
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"

                Behavior on opacity {
                    NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
                }
            }

            states: [
                State {
                    name: "hide"
                    PropertyChanges { target: imageRect; opacity: 0; y: imageTitle.y + imageTitle.height - imageRect.height}
                    PropertyChanges { target: imagePreview; opacity: 0 }
                    PropertyChanges { target: imagePreviewName; opacity: 0 }
                    when: addPanel.imagePreviewState == "hide"
                },

                State {
                    name: "show"
                    PropertyChanges { target: imageRect; opacity: 0.3; y: imageTitle.y + imageTitle.height + 15}
                    PropertyChanges { target: imagePreview; opacity: 1 }
                    PropertyChanges { target: imagePreviewName; opacity: 1 }
                    when: addPanel.imagePreviewState == "show"
                }
            ]

            Image {
                id: imageButton
                source: "qrc:/images/camera.png"
                sourceSize.width: 24; sourceSize.height: 24
                anchors.right: imageRect.right
                //anchors.top: imageRect.bottom; anchors.topMargin: 15
                y: imageTitle.y

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        imageManagerLoader.source = "qrc:/qml/ImageManager.qml";
                        addPanel.imagePreviewState = "hide";
                    }
                }
            }

            CheckBox {
                id: printCheckbox
                anchors.top: imageRect.bottom
                anchors.topMargin: 20
                anchors.left: imageTitle.left
                anchors.leftMargin: 4
            }

            Rectangle {
                id: okButton
                anchors.left: detailEdit.left
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
                    font.family: "微软雅黑"
                    smooth: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        okButton.color = "#d54d34"
                    }
                    onClicked: {
                        if (nameTextEdit.text == "" || priceTextEdit.text == ""
                            || detailTextEdit.text == "" || addPanel.addedImage == "") {
                        }
                        else {
                            if (addPanel.state == "view") {
                                var index = grid.model.count - 1;
                                var maxiid = idManager.createID();;
                                grid.model.insert(index, {"iid": maxiid, "cid": Global.cid, "tag": "", "name": nameTextEdit.text, "image": imagePreview.source, "detail": detailTextEdit.text, "price": priceTextEdit.text, "style": "IMAGE_RECT"});
                            }
                            else if (addPanel.state == "edit") {
                                var index = 0;
                                while (index < grid.model.count) {
                                    if (grid.model.get(index).iid == addPanel.rectIid) {
                                        grid.model.get(index).name = nameTextEdit.text;
                                        grid.model.get(index).image = imagePreview.source;
                                        grid.model.get(index).detail = detailTextEdit.text;
                                        grid.model.get(index).price = priceTextEdit.text;
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
                anchors.right: detailEdit.right
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
                    font.family: "微软雅黑"
                    smooth: true
                }

                MouseArea {
                    anchors.fill: parent
                    onPressed: {
                        cancelButton.color = "#d54d34"
                    }
                    onClicked: {
                        clearEdit();
                        addPanel.x = 1280;
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
        priceTextEdit.text = '';
        detailTextEdit.text = '';
        addPanel.imagePreviewState = "hide";
    }

    function refreshEdit() {
        nameTextEdit.text = Global.checkedName;
        priceTextEdit.text = Global.checkedPrice;
        detailTextEdit.text = Global.checkedDetail;
        addPanel.addedImage = Global.checkedImage;
        imagePreviewState = "show";
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
