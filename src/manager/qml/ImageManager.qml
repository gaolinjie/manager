import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: itemsScreen
    width: 1280
    height: 800
    clip: true
    Component.onCompleted: {
        timer.running = true;
    }

    Rectangle {
        id: itemsView
        width: parent.width; height: parent.height
        color: "#3E2C5A"
        anchors.verticalCenter: parent.verticalCenter
        smooth: true
        property string state: "back"

        Text {
            id: viewTitle
            anchors.left: parent.left; anchors.top: parent.top
            anchors.leftMargin: 100; anchors.topMargin: 70
            text: "图 片"
            font.pixelSize: 50
            color: "white"
        }
/*
        GridView {
            id: imageGrid
            width: 1180; height: 432
            cellWidth: 210
            cellHeight: 144
            anchors.left: viewTitle.left
            anchors.top: viewTitle.bottom; anchors.topMargin: 50
            model: ImageManagerModel{}
            delegate: ImageManagerDelegate{}
            smooth: true
            flow: GridView.TopToBottom
            cacheBuffer: 1000
        }*/

        Loader {
            id: imageGrid
            //x: viewTitle.x + 300
            anchors.left: viewTitle.left//; anchors.leftMargin: 100
            anchors.top: viewTitle.bottom; anchors.topMargin: 50
            source: ""//"qrc:/qml/ImageGrid.qml"


        }

        Timer {
            id: timer
            interval: 5
            running: false
            onTriggered: {
                imageGrid.source = "qrc:/qml/ImageGrid.qml";
            }
        }

        Text {
            id: selectedTitle
            text: "已选中的图片"
            font.pixelSize: 16
            color: "white"
            anchors.left: imageGrid.left; anchors.leftMargin: 4
            anchors.top: viewTitle.bottom; anchors.topMargin: 520
            opacity: 0.8
        }

        ListView {
            id: selectedImageList
            width: 1180; height: 144*0.4
            model: selectedImageModel
            delegate: selectedImageDelegate
            spacing: 10
            smooth: true
            orientation: ListView.Horizontal
            anchors.left: selectedTitle.left
            anchors.top: selectedTitle.bottom; anchors.topMargin: 30

            Component {
                id: selectedImageDelegate
                Image {
                    source: image
                    sourceSize.width: 210*0.4
                    sourceSize.height: 144*0.4
                }
            }

            ListModel {
                id: selectedImageModel
            }
        }

        Rectangle {
            id: okButton
            anchors.right: cancelButton.left; anchors.rightMargin: 20
            anchors.bottom: cancelButton.bottom
            width: 105; height: 27
            color: "#3E2C5A"
            border.color: "white"
            border.width: 2

            Text {
                text: "导 入"
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    okButton.color = "#d54d34"
                }
                onClicked: {
                    addPanel.addedImageName = selectedImageList.model.get(0).name;
                    addPanel.addedImage = selectedImageList.model.get(0).image;
                    imageManagerLoader.source = "";
                    addPanel.imagePreviewState = "show";
                }
                onReleased: {
                    okButton.color = "#3E2C5A"
                }
            }
        }

        Rectangle {
            id: cancelButton
            anchors.right: parent.right; anchors.rightMargin: 60
            anchors.bottom: selectedImageList.bottom
            width: 105; height: 27
            color: "#3E2C5A"
            border.color: "white"
            border.width: 2

            Text {
                text: "取 消"
                anchors.centerIn: parent
                color: "white"
                font.pixelSize: 14
            }

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    cancelButton.color = "#d54d34"
                }
                onClicked: {
                    imageManagerLoader.source = "";
                    addPanel.imagePreviewState = "show";
                }
                onReleased: {
                    cancelButton.color = "#3E2C5A"
                }
            }
        }

        states: [
            State {
                name: "back"
                PropertyChanges { target: itemsView; x: 0}
                when: itemsView.state == "back"
            },

            State {
                name: "gone"
                PropertyChanges { target: itemsView; x: -1024}
                when: itemsView.state == "gone"
            }
        ]

        transitions: [
            Transition {
                from: ''; to: 'back'
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
