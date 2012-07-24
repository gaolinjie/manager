import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: itemsScreen
    width: 1280; height: 800
    signal loadStart()

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

    Timer {
        id: timer3
        interval: 10
        running: false
        onTriggered: {
            seatView.source = "qrc:/qml/SeatGrid.qml"
        }
    }

    Rectangle {
        id: mainView
        width: parent.width; height: parent.height
        color: "#BABAB9"
        anchors.verticalCenter: parent.verticalCenter
        transform: Rotation { id: viewRotation; origin.x: parent.width * 0.8; origin.y: parent.height * 0.8 * 0.5 + 100; axis { x: 0; y: 1; z: 0 } angle: -70 }
        smooth: true
        property string state: "back"

        Text {
            id: viewTitle
            anchors.left: parent.left; anchors.top: parent.top
            anchors.leftMargin: 125; anchors.topMargin: 70
            text: Global.title
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 50
            color: "black"
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

        Text {
            id: printerTitle
            anchors.left: viewTitle.left
            anchors.top: viewTitle.bottom; anchors.topMargin: 40
            text: "所有打印机"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 30
            color: "black"
        }

        Text {
            id: printerDesciption
            anchors.left: printerTitle.left
            anchors.top: printerTitle.bottom; anchors.topMargin: 10
            text: "点击下面的打印机,在右边会显示详细的打印机配置信息."
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            color: "black"
        }

        PrinterGrid {
            id: printerGrid
            anchors.left: printerDesciption.left
            anchors.top: printerDesciption.bottom; anchors.topMargin: 40
        }

        Loader{
            id: printerDetailLoader
            source: printerGrid.model.count > 1 ? "qrc:/qml/PrinterDetail.qml" : ""
            anchors.left: printerTitle.left; anchors.leftMargin: 727
            anchors.top: printerTitle.top
        }

        Rectangle {
            id: foreground
            width: 1280; height: 800
            anchors.centerIn: parent
            color: "black"
            opacity: 0.7
            visible: false
        }

        AddPrinterDialog {
            id: addPrinterDialog
            y: 800
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
