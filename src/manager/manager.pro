QT += core gui
QT += core gui declarative
QT += network
QT += sql

SOURCES += \
    main.cpp \
    imagemanager.cpp \
    client.cpp \
    server.cpp \
    clientsocket.cpp \
    syncmanager.cpp

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
    qml/ImageGrid.qml \
    images/yen_currency_sign.png \
    images/users.png \
    images/process.png \
    images/print.png \
    images/map_pin.png \
    images/dollar_currency_sign.png \
    images/chart.png \
    images/address_book.png \
    qml/SeatView.qml \
    qml/SeatCategory.qml \
    qml/SeatGrid.qml \
    images/label.png \
    qml/PrinterView.qml \
    qml/comingsoon.qml \
    images/store.png \
    qml/PrinterGrid.qml \
    images/minus.png \
    qml/PrinterDetail.qml \
    qml/Tag.qml \
    images/tag_mid.png \
    images/tag_front.png \
    images/tag_back.png \
    images/background1.png \
    images/tag.png \
    images/tag_add.png \
    images/add_rect.png \
    images/add.png \
    qml/AddPrinterDialog.qml \
    qml/CategoryTagGrid.qml \
    qml/CategoryListView.qml \
    images/refresh.png \
    qml/SyncView.qml \
    images/animated_loader.gif \
    qml/BusyIndicator.qml

RESOURCES += \
    resource.qrc

HEADERS += \
    imagemanager.h \
    client.h \
    server.h \
    clientsocket.h \
    syncmanager.h
