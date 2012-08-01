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
                width: 320; height: 60
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
                sourceSize.width: 68; sourceSize.height: 42
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
                    PropertyChanges { target: selectPrinterComboBox; dropDown: true }
                    when: addPanel.imagePreviewState == "hide"
                },

                State {
                    name: "show"
                    PropertyChanges { target: imageRect; opacity: 0.3; y: imageTitle.y + imageTitle.height + 15}
                    PropertyChanges { target: imagePreview; opacity: 1 }
                    PropertyChanges { target: imagePreviewName; opacity: 1 }
                    PropertyChanges { target: selectPrinterComboBox; dropDown: false }
                    when: addPanel.imagePreviewState == "show"
                }
            ]

            Image {
                id: imageButton
                source: "qrc:/images/camera.png"
                sourceSize.width: 26; sourceSize.height: 26
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

            Text {
                id: printSettingTitle
                text: "打印设置:"
                anchors.left: imageTitle.left
                anchors.top: imageRect.bottom; anchors.topMargin: 20
                font.pixelSize: 16
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }

            CheckBox {
                id: printCheckbox
                anchors.top: printSettingTitle.bottom
                anchors.topMargin: 15
                anchors.left: printSettingTitle.left
                anchors.leftMargin: 4
                backColor: "#de9317"
                foreColor: "#d54d34"
                property int isNeedPrint: checked?1:0
                checked: true

                onOperate: {
                    if (printCheckbox.checked) {
                        printCheckbox.isNeedPrint = 1;

                    }
                    else {
                        printCheckbox.isNeedPrint = 0;
                    }
                    console.log(printCheckbox.isNeedPrint )
                }
            }

            Text {
                id: printCheckBoxTitle
                text: "是否需要发送到厨房"
                anchors.left: printCheckbox.right
                anchors.leftMargin: 10
                anchors.bottom: printCheckbox.bottom
                font.pixelSize: 14
                font.family: "微软雅黑"
                smooth: true
                color: "white"
            }
/*
            Text {
                id: selectPrinterTitle
                text: "选择打印机"
                anchors.left: printCheckbox.left
                anchors.top: printCheckbox.bottom
                anchors.topMargin: 15
                font.pixelSize: 14
                font.family: "微软雅黑"
                smooth: true
                color: "white"
                visible: printCheckbox.checked
            }*/

            ComboBox {
                id: selectPrinterComboBox
                prompt: "请选择打印机"
                anchors.left: printSettingTitle.left
                anchors.top: printCheckbox.bottom
                anchors.topMargin: 15
                visible: printCheckbox.checked
                dropDown: addPanel.addedImage=="" ? true : false
                z: 2
                contentModel: PrinterModel {
                                  id: printModel
                                  readOnly: true
                              }

                property string seletedPrinter: ""
                onOperate: {
                    selectPrinterComboBox.seletedPrinter = selectPrinterComboBox.contentModel.get(index).pid;
                }
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
                    font.family: "微软雅黑"
                    smooth: true
                    font.pixelSize: 16
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
                                grid.model.insert(index, {"iid": maxiid, "cid": Global.cid, "tag": "", "name": nameTextEdit.text, "image": imagePreview.source, "detail": detailTextEdit.text, "price": priceTextEdit.text, "needPrint": printCheckbox.isNeedPrint, "printer": selectPrinterComboBox.seletedPrinter, "style": "IMAGE_RECT"});
                            }
                            else if (addPanel.state == "edit") {
                                var index = 0;
                                while (index < grid.model.count) {
                                    if (grid.model.get(index).iid == addPanel.rectIid) {
                                        grid.model.get(index).name = nameTextEdit.text;
                                        grid.model.get(index).image = imagePreview.source;
                                        grid.model.get(index).detail = detailTextEdit.text;
                                        grid.model.get(index).price = priceTextEdit.text;
                                        grid.model.get(index).needPrint = printCheckbox.isNeedPrint;
                                        if (printCheckbox.isNeedPrint == 1) {
                                            grid.model.get(index).printer = selectPrinterComboBox.seletedPrinter;
                                        }
                                        else {
                                            grid.model.get(index).printer = "gvvv";
                                        }
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
        printCheckbox.checked = true
        selectPrinterComboBox.prompt = "请选择打印机";
    }

    function refreshEdit() {
        nameTextEdit.text = Global.checkedName;
        priceTextEdit.text = Global.checkedPrice;
        detailTextEdit.text = Global.checkedDetail;
        addPanel.addedImage = Global.checkedImage;
        imagePreviewState = "show";
        printCheckbox.checked = Global.checkedNeedPrint;
        var index = 0;
        while (index < selectPrinterComboBox.contentModel.count) {
            if (Global.checkedPrinter == selectPrinterComboBox.contentModel.get(index).pid) {
                selectPrinterComboBox.prompt = selectPrinterComboBox.contentModel.get(index).name
            }
            index++;
        }
        selectPrinterComboBox.seletedPrinter = Global.checkedPrinter;
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
