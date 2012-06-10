// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Item {
    id: imageManagerDelegate
    width: imageGrid.cellWidth; height: imageGrid.cellHeight

    Image {
        id: img
        source: image
        sourceSize.width: imageGrid.cellWidth - 8
        sourceSize.height: imageGrid.cellHeight - 8
        anchors.centerIn: parent

        MouseArea {
            anchors.fill: parent
            onClicked: {
                if (checkRect.visible == true) {
                    checkRect.visible = false;
                    selectedImageList.model.remove(selectedImageList.model.count - 1)
                }
                else {
                    checkRect.visible = true;
                    selectedImageList.model.append({"name": name, "image": image})
                }
            }
        }

        Image {
            id: checkRect
            source: "qrc:/images/checkrect2.png"
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
    }


}


