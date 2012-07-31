// import QtQuick 1.0 // to target S60 5th Edition or Maemo 5
import QtQuick 1.1

ListModel {
    id: imageManagerModel
    Component.onCompleted: loadItemsData()

    function loadItemsData() {
        imageManager.construct();
        var index = 0;
        while (index < imageManager.getCount()) {
            var name = imageManager.getImageName(index);
            var image = imageManager.getImage(index);
            imageManagerModel.append({"name": name, "image": image});
            index++;
        }
        //imageManager.deconstruct();
    }
/*
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}
    ListElement {name: "image1"; image: "qrc:/images/BerryPie.png"}*/
}
