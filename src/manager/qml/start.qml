import QtQuick 1.0

Item {
    id: start
    width: 1280; height: 800
    clip: true

    signal loadRect(string qmlFile)

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/images/background.png"
    }

    Text {
        id: startText
        x: 130; y: 70
        text: "菜 单"
        font.family: "Vera Sans YuanTi"
        font.pixelSize: 50
        color: "white"
        opacity: 0

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
            startText.x = 90
            startText.opacity = 1
        }
    }

    StartView {
        id: startView
        x:550; y:201

        Behavior on x {
            NumberAnimation {duration: 1600; easing.type: Easing.OutQuint}
        }
        Behavior on y {
            NumberAnimation {duration: 1000; easing.type: Easing.OutQuint}
        }

        Component.onCompleted: {
            timer.running = true
            startView.x = 30
        }
    }

    AddPanel {
        id: addPanel
        x: parent.width - addPanel.width
        y: 0
    }
}
