// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

Rectangle {
    id: checkBox
    property bool checked: false
    property string backColor: "#de9317"
    property string foreColor: "#d54d34"

    signal clicked( bool checked )
    signal operate

    Component.onCompleted: {
        if (!checked)
            checkedIcon.visible = false
        else
            checkedIcon.visible = true
    }

    width: 18
    height: 18
    color: backColor
    border.width: 2
    border.color: "white"
    smooth: true
    radius: 1

    Image {
        id: checkedIcon
        source: "qrc:/images/check.png"
        sourceSize.width: checkBox.width //- 2
        sourceSize.height: checkBox.height //- 2
        anchors.centerIn: parent
    }

    MouseArea {
        id: mouseArea

        anchors.fill: parent
        onClicked: {
            checked = !checked;
            checkBox.clicked( checked );
            checkBox.operate();
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
        PropertyChanges { target: checkBox; border.color: "white"; color: foreColor}
        }
    ]
}

