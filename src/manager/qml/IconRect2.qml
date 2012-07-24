import QtQuick 1.0
import "../js/global.js" as Global

Rectangle {
    id: rect
    x: wraper.x + 5; y: wraper.y + 5
    width: wraper.width - 10; height: wraper.height - 10;
    parent: loc
    clip: true
    color: backColor
    smooth: true

    Connections{
        target: grid
        onPressAndHoldRect: {
            if (rectId == cid) {
                addPanel.x = 1280;
                checkRect.visible = true;
                Global.checkedBackColor = backColor;
                Global.checkedForeColor = foreColor;
                Global.checkedTitle = title;
                Global.checkedCid = cid;
            }
            else {
                bx.enabled = true;
                by.enabled = true;
                checkRect.visible = false;
            }
        }
        onReleasedRect: {
            bx.enabled = false;
            by.enabled = false;
        }
    }

    Image {
        id: icon
        x: 50
        anchors.verticalCenter: parent.verticalCenter
        source: image
        sourceSize.width: 90
        sourceSize.height: 90
    }

    Text {
        id: text
        x: 150
        anchors.verticalCenter: parent.verticalCenter
        anchors.left: icon.right
        anchors.leftMargin: 20
        text: title
        font.pixelSize: 30
        font.family: "微软雅黑"
        color: "white"
        smooth: true
    }

    Image {
        id: checkRect
        source: "qrc:/images/checkrect.png"
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        visible: false
        smooth: true

        Image {
            id: checkIcon
            source: "qrc:/images/check.png"
            sourceSize.width: 32
            sourceSize.height: 32
            anchors.top: parent.top
            anchors.right: parent.right
            smooth: true
        }
    }

    Behavior on x { id: bx; enabled: false; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }
    Behavior on y { id: by; enabled: false; NumberAnimation { duration: 400; easing.type: Easing.OutBack } }

    states: State {
        name: "active"; when: loc.currentId == cid
        PropertyChanges { target: rect; x: loc.mouseX - width/2; y: loc.mouseY - height/2; scale: 0.7; z: 10 }
    }
    transitions: Transition { NumberAnimation { property: "scale"; duration: 200} }
}
