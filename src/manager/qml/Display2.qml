import QtQuick 1.0

Rectangle {
    property alias text : displayText.text

    Text {
        id: displayText
        anchors.centerIn: parent
        font.family: "微软雅黑"
            font.pixelSize: 66
        color: "white"; smooth: true
        text: ""
    }
}
