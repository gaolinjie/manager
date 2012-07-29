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
        onClickedRect: {
            console.log("onClickedRect" + cid)
            if (rectId == cid) {
                Global.backColor = backColor;
                Global.foreColor = foreColor;
                Global.title = title;
                Global.cid = cid;
                loadRect(slotQml);
            }
        }
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
        id: imageNow
        source: image
        sourceSize.width: parent.width
        sourceSize.height: parent.height
        smooth: true
    }


    Rectangle {
        id: titleRect
        width: parent.width; height: 40
        color: foreColor
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        smooth: true
    }

    Text {
        id: text
        x: 40
        anchors.verticalCenter: titleRect.verticalCenter
        text: title
        font.family: "微软雅黑"
        font.pixelSize: 20
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
