import QtQuick 1.0

BorderImage {
    id: button
    smooth: true

    property alias operation: buttonText.text
    property string color: ""
    property int textSize: 1

    signal operate

    source: "qrc:/images/button-" + color + ".png"; clip: true
    border { left: 10; top: 10; right: 10; bottom: 10}

    Rectangle {
        id: shade
        anchors.fill: button; radius: 10; color: "black"; opacity: 0
        smooth: true
    }

    Text {
        id: buttonText
        anchors.centerIn: parent; anchors.verticalCenterOffset: -1
        font.pixelSize: textSize
        font.family: "微软雅黑"
        smooth: true
        style: Text.Sunken; color: "white"; styleColor: "black"
        font.bold: true
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: {
            doOp(operation)
            button.operate()
        }
    }

    states: State {
        name: "pressed"; when: mouseArea.pressed == true
        PropertyChanges { target: shade; opacity: .4 }
    }
}
