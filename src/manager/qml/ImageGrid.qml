// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

GridView {
    id: imageGrid
    width: 1180; height: 432
    cellWidth: 210
    cellHeight: 144
    model: ImageManagerModel{}
    delegate: ImageManagerDelegate{}
    smooth: true
    flow: GridView.TopToBottom
    cacheBuffer: 1000
    x: 100

    Component.onCompleted: {
        imageGrid.x = 0
    }

    Behavior on x {
        NumberAnimation { duration: 600; easing.type: Easing.OutQuint}
    }
}
