// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: colorPicker
    width: 320; height: 36
    border.color: "white"
    border.width: 2

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true

        onClicked: {
            picker.visible = true;
        }
    }

    Rectangle {
        id: picker
        width: 324
        height: 124
        radius: 4
        color: "#343434"
        anchors.top: parent.bottom; anchors.topMargin: 9
        anchors.left: parent.left; anchors.leftMargin: -2
        visible: false

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
                        color: backColor
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
                                colorPicker.color = backColor;
                                picker.visible = false;
                            }
                        }
                    }
                }
            }

            ListModel {
                id: colorModel
                ListElement {
                    name: "yellow"
                    backColor: "#FABE28"
                }
                ListElement {
                    name: "bright-yellow"
                    backColor: "#FFFF33"
                }
                ListElement {
                    name: "blue"
                    backColor: "#63D3FF"
                }
                ListElement {
                    name: "cyan"
                    backColor: "#00FFFF"
                }
                ListElement {
                    name: "red"
                    backColor: "#FF4E50"
                }
                ListElement {
                    name: "green"
                    backColor: "#00C176"
                }
                ListElement {
                    name: "pink"
                    backColor: "#FF0066"
                }
                ListElement {
                    name: "light-pink"
                    backColor: "#FF3D7F"
                }
                ListElement {
                    name: "orange"
                    backColor: "#F38630"
                }
                ListElement {
                    name: "purple"
                    backColor: "#9061C2"
                }
                ListElement {
                    name: "light-green"
                    backColor: "#B3CC57"
                }
                ListElement {
                    name: "cube-green"
                    backColor: "#CCFF00"
                }
            }
        }
    }
}

