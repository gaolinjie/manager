import QtQuick 1.1
import "../js/global.js" as Global

Item {
    id: rect
    x: wraper.x + 5; y: wraper.y + 5
    width: wraper.width - 10; height: wraper.height - 10;
    clip: true
    parent: loc

    transform: Rotation {
        id: rotation;
        origin.x: parent.width * 0.5;
        origin.y: 0//parent.height * 0.5;
        axis { x: 1; y: 0; z: 0 }
        angle: 0
    }
/*
    Connections{
        target: grid
        onClickedRect: {
            if (rectId == cid) {
                addPanel.state = "view"
                addPanel.x = 880

            }
        }
    }*/

    MouseArea{
        anchors.fill: parent
        onPressed: {
            rotation.angle = -15;
        }
        onClicked: {
            addPanel.state = "view"
            addPanel.x = 880
            grid.pressAndHoldRect(-1);
            bottomBar.y = 800
        }
        onReleased: {
            rotation.angle = 0;
        }
    }

    Image {
        id: imageNow
        source: image
        opacity: 0.3
    }
}
