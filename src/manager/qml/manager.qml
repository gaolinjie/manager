import QtQuick 1.0

Item {
    id: manager
    width: 1280; height: 800
    clip: true

    signal loadRect(string qmlFile)

    Image {
        id: background
        anchors.fill: parent
        source: "qrc:/images/background.png"
    }

    Text {
        id: titleText
        x: 130; y: 70
        text: "管 理"
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
            titleText.x = 90
            titleText.opacity = 1
        }
    }

    ManagerView {
        id: managerView
        x:550; y:201

        Behavior on x {
            NumberAnimation {duration: 1600; easing.type: Easing.OutQuint}
        }

        Component.onCompleted: {
            timer.running = true
            managerView.x = 30
        }
    }    
}
