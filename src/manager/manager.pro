QT += core gui
QT += core gui declarative
QT += network
QT += sql

SOURCES += \
    main.cpp \
    imagemanager.cpp

OTHER_FILES += \
    qml/main.qml \
    qml/manager.qml \
    qml/ManagerView.qml \
    qml/ImageRect.qml \
    qml/IconRect.qml \
    js/global.js \
    images/note.png \
    images/background.png \
    qml/start.qml \
    images/add.png \
    qml/AddRect.qml \
    images/pattern.png \
    images/wood.png \
    qml/StartView.qml \
    qml/AddPanel.qml \
    images/shadow.png \
    qml/AddList.qml \
    images/sett-big.png \
    images/search.png \
    images/POI.png \
    images/favs.png \
    qml/ColorPicker.qml \
    images/triangle.png \
    images/menu_image.png \
    images/next.png \
    images/back.png \
    qml/StartDelegate.qml \
    qml/StartModel.qml \
    images/cancel.png \
    images/edit.png \
    images/down.png \
    images/delete.png \
    images/check.png \
    images/checkrect.png \
    qml/ItemsView.qml \
    qml/ItemDelegate.qml \
    qml/ItemRect.qml \
    images/BerryPie.png \
    qml/ItemGrid.qml \
    qml/ItemModel.qml \
    qml/AddItemPanel.qml \
    qml/ImageManager.qml \
    qml/ImageManagerModel.qml \
    qml/ImageManagerDelegate.qml \
    images/checkrect2.png \
    images/camera.png \
    qml/ImageGrid.qml

RESOURCES += \
    resource.qrc

HEADERS += \
    imagemanager.h
