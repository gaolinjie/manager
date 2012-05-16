import QtQuick 1.0
import "../js/global.js" as Global

Item {
    id: rect
    width: parent.width
    height: parent.height
    clip: true

    property string iconSource: ""
    property string iconTitle: ""

    MouseArea{
        anchors.fill: parent
        onClicked: {
            Global.cid = cid
            Global.backColor = backColor
            Global.foreColor = foreColor
            Global.title = title
            loadRect(slotQml)
        }
    }

    Rectangle {
        id: backRect
        width: parent.width; height: parent.height
        color: backColor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        opacity: 0.8
    }

    Image {
        id: imageNow
        source: image
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        Behavior on y {
            NumberAnimation { duration: 1000; easing.type: Easing.OutQuint}
        }
    }

    Rectangle {
        id: titleRect
        width: parent.width; height: 40
        color: foreColor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        opacity: 0.8
    }

    Text {
        id: text
        x: 40
        anchors.verticalCenter: titleRect.verticalCenter
        text: parent.iconTitle
        font.pixelSize: 20
        color: "white"
    }
}
