import QtQuick 1.1
import "../js/global.js" as Global

Item {
    id: rect
    width: parent.width
    height: parent.height
    clip: true

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
            addPanel.x = 880
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
