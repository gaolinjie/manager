// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: tag
    width: frontTag.width + midTag.width + backTag.width
    height: 24
    property string name: ""

    Image {
        id: frontTag
        source: "qrc:/images/tag_front.png"
        anchors.left: parent.left
    }

    Image {
        id: midTag
        source: "qrc:/images/tag_mid.png"
        width: tagName.width + 8
        anchors.left: frontTag.right

        Text {
            id: tagName
            text: tag.name
            anchors.centerIn: parent
            color: "black"
            font.pixelSize: 10
        }
    }

    Image {
        id: backTag
        source: "qrc:/images/tag_back.png"
        anchors.left: midTag.right
    }
}
