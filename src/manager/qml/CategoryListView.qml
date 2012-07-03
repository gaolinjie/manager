// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListView {
    id: categoryListView
    width: 150
    height: 300
    model: StartModel{}
    delegate: categoryDelegate
    spacing: 10
    smooth: true

    Component {
        id: categoryDelegate
        Text {
            id: categoryName
            text: title
            font.pixelSize: 15
            color: "white"

            MouseArea {
                anchors.fill: parent
                onPressed: {
                    categoryName.color = "#de9317"
                }
                onClicked: {
                    categoryListView.parent.visible = false;
                    categoryTagGrid.model.remove(categoryTagGrid.model.count-1);
                    categoryTagGrid.model.append({"cid": cid, "cate": title});
                    categoryTagGrid.model.append({"cid": -1, "cate": ""});
                }
                onReleased: {
                    categoryName.color = "white"
                }
            }
        }
    }
}