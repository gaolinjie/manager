// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1
import "../js/global.js" as Global

GridView {
    id: grid
    width: (grid.count/3+1)*grid.cellWidth; height: 480
    cellWidth: 310
    cellHeight: 160
    model: MenuGridModel{ id: rects }
    delegate: MenuGridDelegate{}
    smooth: true
    flow: GridView.TopToBottom
    interactive: false
    signal clickedRect(string rectId)
    signal pressAndHoldRect(string rectId)
    signal releasedRect(string rectId)
    property string checkedIndex: ""

    Component.onCompleted: {
        timer.running = true
    }

    Timer {
        id: timer
        interval: 10
        onTriggered: {
            grid.model.reloadItemsData()
        }
    }

    MouseArea {
        property string currentId: ""                    // Original position in model
        property int newIndex                            // Current Position in model
        property int index: grid.indexAt(mouseX, mouseY) // Item underneath cursor
        property int offset: -1
        id: loc
        anchors.fill: parent
        onClicked: {
            clickedRect(grid.model.get(index).tid)
            //console.log("clickedRect" + grid.model.get(index).tid)
        }
        onPressAndHold: {
            Global.mouseHolding = 1;
            if (flick.interactive == true) {
                flick.interactive = false;
            }
            currentId = grid.model.get(newIndex = index).tid;
            console.log("clickedRect" + currentId)
            grid.checkedIndex = currentId;
            pressAndHoldRect(currentId);
            bottomBar.y = 700;
        }
        onReleased: {
            Global.mouseHolding = 0;
            currentId = "";
            flick.interactive = true;
            releasedRect(currentId);
        }
        onMousePositionChanged: {
            if (loc.currentId != "" && index != -1 && index != newIndex)
                rects.move(newIndex, newIndex = index, 1)
            if (offset < 0) {
                var n = 0;
                while (n*grid.cellWidth < flick.width) {
                    n++;
                }
                offset = n*grid.cellWidth - flick.width;
            }

            var cols;
            if (grid.count%3 == 0) {
                cols = grid.count/3;
            }
            else {
                cols = grid.count/3 + 1;
            }
            if (mouseX < flick.contentX) {
                if (flick.contentX > grid.cellWidth + offset) {
                    flick.contentX = ((flick.contentX - offset)/grid.cellWidth - 1) * grid.cellWidth
                }
                else {
                    flick.contentX = 0
                }
            }
            else if (mouseX > flick.contentX + flick.width) {
                if (flick.contentX <= 0) {
                    flick.contentX = offset
                }
                else if (flick.contentX > cols*grid.cellWidth-flick.width - grid.cellWidth) {
                    flick.contentX = cols*grid.cellWidth-flick.width + grid.cellWidth
                }
                else {
                    flick.contentX = ((flick.contentX - offset)/grid.cellWidth + 1) * grid.cellWidth + offset
                }
            }
        }
    }
}
