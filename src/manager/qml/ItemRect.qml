// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

Item {
    id: rect
    x: wraper.x + 5; y: wraper.y + 5
    width: wraper.width - 10; height: wraper.height - 10;
    parent: loc
    clip: true
    smooth: true

    Connections{
        target: grid
        onClickedRect: {
            if (rectId == cid) {
                //Global.backColor = backColor
                //Global.foreColor = foreColor
                //Global.title = title
                //loadRect(slotQml);
            }
        }
        onPressAndHoldRect: {
            if (rectId == iid) {
                addPanel.x = 1280;
                checkRect.visible = true;
                Global.checkedName = name;
                Global.checkedPrice = price;
                Global.checkedDetail = detail;
                Global.checkedImage = image;
                Global.checkedIid = iid;
            }
            else {
                console.log("dd")
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
        id: itemImage
        source: image
        sourceSize.width: rect.width
        sourceSize.height: rect.height - 32
        smooth: true
    }

    Rectangle {
        id: nameRect
        width: parent.width; height: 32
        anchors.left: parent.left
        anchors.bottom: parent.bottom
        color: Global.foreColor
        smooth: true

        Text {
            id: nameText
            text: name
            anchors.left: parent.left; anchors.leftMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 14
            color: "white"
        }

        Text {
            id: priceText
            text: "￥ " + price + " 元"
            anchors.right: parent.right; anchors.rightMargin: 10
            anchors.verticalCenter: parent.verticalCenter
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 14
            color: "white"
        }
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
        name: "active"; when: loc.currentId == iid
        PropertyChanges { target: rect; x: loc.mouseX - width/2; y: loc.mouseY - height/2; scale: 0.7; z: 10 }
    }
    transitions: Transition { NumberAnimation { property: "scale"; duration: 200} }
}
