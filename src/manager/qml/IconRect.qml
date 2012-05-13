import QtQuick 1.0
import "../js/global.js" as Global

Rectangle {
    id: rect
    width: parent.width
    height: parent.height
    color: rectColor
    smooth: true

    property string iconSource: ""
    property string iconTitle: ""

    transform: Rotation {
        id: rotation;
        origin.x: parent.width * 0.5;
        origin.y: 0//parent.height * 0.5;
        axis { x: 1; y: 0; z: 0 }
        angle: 0
    }

    MouseArea{
        anchors.fill: parent
        onPressed: {
            rotation.angle = -15;
        }
        onClicked: {
            Global.rectColor = rectColor
            Global.hotColor = hotColor
            Global.title = title
            loadRect(slotQml)
        }
        onReleased: {
            rotation.angle = 0;
        }
    }

    Image {
        id: icon
        x: 50
        anchors.verticalCenter: parent.verticalCenter
        source: parent.iconSource
        sourceSize.width: 90
        sourceSize.height: 90
    }

    Text {
        id: text
        x: 150
        anchors.verticalCenter: parent.verticalCenter
        text: parent.iconTitle
        font.pixelSize: 30
        color: "white"
    }
}
