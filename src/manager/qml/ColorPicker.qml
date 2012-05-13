// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    width: 320
    height: 124
    radius: 4
    color: "#343434"

    Image {
        id: triangle
        source: "qrc:/images/triangle.png"
        y: -61
        smooth: true
        anchors.horizontalCenter: parent.horizontalCenter
    }

    GridView {
        id: colorView
        model: colorModel
        delegate: colorDelegate
        cellWidth: 48
        cellHeight: 48
        width: parent.width - 32
        height: parent.height - 28
        anchors.centerIn: parent
        interactive: false



        Component {
            id: colorDelegate
            Item {
                width: colorView.cellWidth; height: colorView.cellHeight
                Rectangle {
                    id: colorRect
                    width: 42
                    height: 42
                    color: rectColor
                    radius: 4
                    anchors.centerIn: parent
                    smooth: true

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            colorRect.width = 40;
                            colorRect.height = 40;
                        }
                        onExited: {
                            colorRect.width = 42;
                            colorRect.height = 42;
                        }
                        onClicked: {
                            console.log("fff")
                        }
                    }
                }
            }
        }

        ListModel {
            id: colorModel
            ListElement {
                name: "yellow"
                rectColor: "#FABE28"
            }
            ListElement {
                name: "bright-yellow"
                rectColor: "#FFFF33"
            }
            ListElement {
                name: "blue"
                rectColor: "#63D3FF"
            }
            ListElement {
                name: "cyan"
                rectColor: "#00FFFF"
            }
            ListElement {
                name: "red"
                rectColor: "#FF4E50"
            }
            ListElement {
                name: "green"
                rectColor: "#00C176"
            }
            ListElement {
                name: "pink"
                rectColor: "#FF0066"
            }
            ListElement {
                name: "light-pink"
                rectColor: "#FF3D7F"
            }
            ListElement {
                name: "orange"
                rectColor: "#F38630"
            }
            ListElement {
                name: "purple"
                rectColor: "#9061C2"
            }
            ListElement {
                name: "light-green"
                rectColor: "#B3CC57"
            }
            ListElement {
                name: "cube-green"
                rectColor: "#CCFF00"
            }
        }
    }
}
