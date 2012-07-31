// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: checkBox;
    property bool checked: false

    signal clicked( bool checked )

    Component.onCompleted: {
        if (!checked)
            checkedIcon.visible = false
        else
            checkedIcon.visible = true
    }

    width: 22
    height: 22
    color: "#de9317"
    border.width: 2
    border.color: "white"
    smooth: true

    Image {
        id: checkedIcon
        source: "qrc:/images/check.png"
        sourceSize.width: 22
        sourceSize.height: 22
        //anchors.fill: parent
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: {
            checked = !checked
            checkBox.clicked( checked )
        }
    }

    states: [
    State {
        id: stateChecked

        name: "checked"; when: checked

        PropertyChanges {
            id: propertyChangeCheckMark

            target: checkedIcon
            visible: checked
        }
        PropertyChanges { target: checkBox; border.color: "white"; color: "#d54d34"}
        }
    ]
}

