import QtQuick 1.0
import "../js/global.js" as Global
import "../js/calculator.js" as CalcEngine

Image {
    id: background
    width: 1280//1280
    height: 800
    source: "qrc:/images/background2.png"
    clip: true
    anchors.centerIn: parent
    //color: "#d54d34"

    Component.onCompleted: {
        //itemsListLoader.source = ''
        //itemsListLoader.source = "qrc:/qml/itemsList.qml"
    }

    signal loadStart()
    signal loadLogin()
    signal mainAddsignal()
    signal mainOrderListUpdateSignal()
    signal mainUpdateItemsignal()
    signal initialOrderList()
    signal mainDiaJumpsignal()
    signal mainCooksignal()
    signal mainCategoryChangeSignal()
    function doOp(operation) { CalcEngine.doOperation2(operation) }

    Connections {
        id: serverConnection
        target: server;
        onRefreshUi: {
            orderList.loadOrderList()
            itemList.loadItemsData()
        }
    }

    Connections {
        id: addConnect
        target: addMenuGrid
        onAddsignal: {
            mainAddsignal()
        }
    }

    Connections {
        id: updateOrderConnect
        target: itemList
        onOrderListUpdateSignal: {
            mainOrderListUpdateSignal()
        }
    }

    Connections {
        id: updateItemConnect
        target: orderList
        onOrderItemUpdateSignal: {
            mainUpdateItemsignal()
            orderList.updateText()
        }
    }

    Connections {
        id: newOrderDialogConnect
        target: newOrderDialog
        onTonewMainfinish: {
            orderList.loadOrderList()
            orderList.finalorderListIndexNO()
            orderList.currentIndex =Global.gorderIndex
            itemList.loadItemsData()
            orderList.updateText()
        }
    }

    Connections {
        id: modifyOrderDialogConnect
        target: modifyOrderDialog
        onTomodifyMainfinish: {
            orderList.loadOrderList()
            orderList.currentIndex =Global.gorderIndex
            itemList.loadItemsData()
            orderList.updateText()
        }
    }

    Connections {
        id: sumCategoryListConnect
        target: sumCategoryList
        onCategoryChangeSignal: {
            mainCategoryChangeSignal()
        }
    }

    Rectangle {
        id: header
        width: background.width; height: 60
        anchors.left: parent.left
        anchors.top: parent.top
        color: "black"
        opacity: 0.8

        Image {
            id: logo
            source: "qrc:/images/logo.png"
            sourceSize.width: 40
            sourceSize.height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left; anchors.leftMargin: 20
        }

        Text {
            id: title
            text: "Colorful POS"
            font.pixelSize: 26
            font.family: "微软雅黑"
            smooth: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: logo.right; anchors.leftMargin: 15
            color: "white"
        }

        // Begin Issue #5, lijunliang, 2012-04-05 //
        Digitalclk {
            width: 230; height: 30
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right; anchors.rightMargin: 15
        }
        // End Issue #5 //
    }

    Rectangle {
        id: ordersRect
        width: 800//600;
        height: 400
        x: 15
        anchors.top: header.bottom; anchors.topMargin: 30
        color: "#e3e3e3"
        radius: 10
        smooth: true
        //opacity: 0.8

        Rectangle {
            id: ordersRectLabel
            width: 100; height: 30
            anchors.left: parent.left; anchors.leftMargin: -10
            anchors.top: parent.top; anchors.topMargin: -10
            color: "#78b117"

            Text {
                text: "未结订单"
                font.pixelSize: 18
                font.family: "微软雅黑"
                smooth: true
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    ordersRectLabel.color = "#78b117"
                    finishRectLabel.color = "grey"
                    Global.pay = "0"
                    Global.oldorderNO ="";
                    Global.gorderIndex = 0;
                    orderList.loadOrderList()
                    itemList.loadItemsData()
                    newOrderButton.height = 40
                    modifyButton.height = 40
                    addButton.height = 40
                    cookButton.height = 40
                }
            }
        }

        Rectangle {
            id: finishRectLabel
            width: 100; height: 30
            anchors.left: ordersRectLabel.right
            anchors.top: parent.top; anchors.topMargin: -10
            color: "grey"

            Text {
                id: finishRectLabelText
                text: "已结订单"
                font.pixelSize: 18
                font.family: "微软雅黑"
                smooth: true
                anchors.centerIn: parent
                color: "white"
            }

            MouseArea {
                anchors.fill: parent
                onClicked: {
                    finishRectLabel.color = "#78b117"
                    ordersRectLabel.color = "grey"
                    Global.pay = "1"
                    Global.oldorderNO ="";
                    Global.gorderIndex = 0;
                    orderList.loadOrderList()
                    itemList.loadItemsData()
                    newOrderButton.height = 0
                    modifyButton.height = 0
                    addButton.height = 0
                    cookButton.height = 0
                }
            }
        }

        Text {
            id: orderNO
            text: "单号"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15            
            anchors.top: parent.top; anchors.topMargin: 30
            anchors.left: parent.left; anchors.leftMargin: 50
            color: "grey"
        }

        Text {
            id: seatNO
            text: "座位"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: orderNO.top
            anchors.left: orderNO.right; anchors.leftMargin: 100
            color: "grey"
        }

        Text {
            id: date
            text: "日期"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: seatNO.top
            anchors.left: seatNO.right; anchors.leftMargin: 100
            color: "grey"
        }

        Text {
            id: time
            text: "时间"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: date.top
            anchors.left: date.right; anchors.leftMargin: 100
            color: "grey"
        }

        Text {
            id: discount
            text: "折扣"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: time.top
            anchors.left: time.right; anchors.leftMargin: 100
            color: "grey"
        }

        Text {
            id: total
            text: "总计"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: discount.top
            anchors.left: discount.right; anchors.leftMargin: 100
            color: "grey"
        }

        OrdersList{
            id: orderList
            anchors.left: parent.left
            anchors.top: parent.top; anchors.topMargin: 68
            Component.onCompleted: {
                orderList.loadOrderList()
                initialOrderList()
            }
        }

        Item  {
               id: ordersButton
               width: 800; height: 60
               anchors.bottom: parent.bottom; anchors.bottomMargin: 0
               anchors.left: parent.left; anchors.leftMargin: 0
               //color: "#cd96cd"
               //radius: 0
               smooth: true
               opacity: 1
               Button {
                   id: newOrderButton
                   width: 380; height: 40
                   anchors.top:parent.top; anchors.topMargin: 5
                   anchors.left:parent.left; anchors.leftMargin: 10
                   //color: 'red'
                   operation: "新建订单"
                   textSize: 16

                   onOperate: {
                       newOrderDialog.x=620+256-46
                       modifyOrderDialog.x=1280
                       //detailRect.x = 1100
                       //rightbord.x = 1100
                       addMenuItem.y = 800
                       //leftbord.x = 15
                       Global.dialogTextNo=2
                       mainDiaJumpsignal()
                   }
               }
               Button {
                   id: modifyButton
                   width: 380; height: 40
                   anchors.top:parent.top; anchors.topMargin: 5
                   anchors.right:ordersButton.right; anchors.rightMargin: 10
                   //color: 'red'
                   operation: "修改订单"
                   textSize: 16

                   onOperate: {
                       modifyOrderDialog.x=620+256
                       //newOrderDialog.x=1100
                       //detailRect.x = 1100
                       //rightbord.x = 1100
                       addMenuItem.y = 800
                       //leftbord.x = 15
                       Global.dialogTextNo = 2
                        mainDiaJumpsignal()
                   }
               }
          }
    }

    Rectangle {
        id: detailRect
        width: 380+56; height: 400
        //x: 630+200
        anchors.left: ordersRect.right
        anchors.leftMargin: 15
        anchors.top: ordersRect.top
        color: "#e3e3e3"
        radius: 10
        smooth: true
        //opacity: 0.8

        Rectangle {
            id: detailRectLabel
            width: 100; height: 30
            anchors.left: parent.left; anchors.leftMargin: -10
            anchors.top: parent.top; anchors.topMargin: -10
            color: "#78b117"

            Text {
                text: "订单详情"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 18
                anchors.centerIn: parent
                color: "white"
            }
        }

        Text {
            id: name
            text: "菜名"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: parent.top; anchors.topMargin: 30
            anchors.left: parent.left; anchors.leftMargin: 34
            color: "grey"
        }

        Text {
            id: price
            text: "单价"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: name.top
            anchors.left: name.right; anchors.leftMargin: 80
            color: "grey"
        }

        Text {
            id: number
            text: "份数"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: price.top
            anchors.left: price.right; anchors.leftMargin: 80
            color: "grey"
        }

        Text {
            id: amount
            text: "小计"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 15
            anchors.top: number.top
            anchors.left: number.right; anchors.leftMargin: 80
            color: "grey"
        }

        ItemsList{
            id: itemList
            anchors.left: parent.left
            anchors.top: parent.top; anchors.topMargin: 68
            Component.onCompleted: itemList.loadItemsData()
            //Component.onDestruction: itemList.saveItemsData()
        }

        Item  {
               id: detailButton
               width: 380+56; height: 60
               anchors.bottom: parent.bottom; anchors.bottomMargin: 0
               anchors.left: parent.left; anchors.leftMargin: 0
               //color: "#cd96cd"
               //radius: 0
               smooth: true
               opacity: 1
               Button {
                   id: addButton
                   width: 160+28; height: 40
                   anchors.top:parent.top; anchors.topMargin: 5
                   anchors.left:parent.left; anchors.leftMargin: 20
                   //color: 'red'
                   operation: "增加菜品"
                   textSize: 16

                   onOperate: {
                        addMenuItem.y = 490
                        rightbord.x = 1280
                        leftbord.x = 1280
                       sumCategoryList.getCategoryList();
                       sumCategoryList.getCategoryModel();
                       sumCategoryList.getfistCategory();
                   }
               }
               Button {
                   id: cookButton
                   width: 160+28; height: 40
                   anchors.top:parent.top; anchors.topMargin: 5
                   anchors.right:parent.right; anchors.rightMargin: 20
                   //color: 'red'
                   operation: "烹制菜品"
                   textSize: 16

                   onOperate: {
                       printOrder.printMenutoKitchen(Global.orderNO)
                       mainCooksignal()
                   }
               }
         }
    }

    Item{
            id: rightbord
            width: detailRect.width; height: 280
            opacity: 1
            anchors.left: detailRect.left
            //x: 630
            anchors.top:  detailRect.bottom; anchors.topMargin: 0
            Rectangle {
                id: dashbord
                width: parent.width; height: 150
                anchors.left: parent.left
                anchors.top: parent.top; anchors.topMargin: 20
                color: "black"
                radius: 10
                smooth: true
                opacity: 1

                gradient: Gradient {
                    GradientStop { position: 0.0;
                                   color: Qt.rgba(0.5,0.5,0.5,0.5) }
                    GradientStop { position: 0.7; color: "black" }
                    GradientStop { position: 1.0; color: "black" }
                }

                Text {
                    id: sumTitle
                    text: "合 计:"
                    anchors.top: parent.top; anchors.topMargin: 15
                    anchors.left: parent.left; anchors.leftMargin: 110
                    font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
                    color: "white"
                }

                Text {
                    id: sumText
                    text: Global.orderNO
                    anchors.top: sumTitle.top
                    anchors.right: parent.right; anchors.rightMargin: 110
                    font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
                    color: "white"
                }

                Text {
                    id: discTitle
                    text: "折 扣:"
                    anchors.top: sumTitle.bottom; anchors.topMargin: 5
                    anchors.left: sumTitle.left
                    font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
                    color: "white"
                }

                Text {
                    id: discText
                    text: ""
                    anchors.top: sumText.bottom; anchors.topMargin: 5
                    anchors.right: sumText.right
                    font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
                    color: "white"
                }

                Text {
                    id: totalText
                    text: sumText.text - discText.text
                    anchors.bottom: parent.bottom; anchors.bottomMargin: 15
                    anchors.horizontalCenter: parent.horizontalCenter
                    font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 55
                    color: "white"
                }
            }
            Button {
                id: cashButton
                width: dashbord.width; height: 40
                anchors.left: dashbord.left
                anchors.top: dashbord.bottom; anchors.topMargin: 10
                color: 'green'
                operation: "现金收取"
                textSize: 16

                onOperate: {
                    foreground.visible = true
                    cashDialog.y = 0
                    keyboardRect.y = 400
                }
            }
            Button {
                id: creditButton
                width: dashbord.width; height: 40
                anchors.left: dashbord.left
                anchors.top: cashButton.bottom; anchors.topMargin: 10
                color: 'purple'
                operation: "刷卡支付"
                textSize: 16

                onOperate: {
                    foreground.visible = true
                    cardDialog.y = 0
                }
            }
    }
    Item{
        id: leftbord
        opacity: 1
        x:15
        anchors.top:  ordersRect.bottom; anchors.topMargin: 0
        Button {
            id: openCashboxButton
            width: 395; height: 40
            anchors.left: parent.left
            anchors.top: parent.top; anchors.topMargin: 20
            operation: "打开钱箱"
            textSize: 16
        }
        Button {
            id: lockSystemButton
            width: 395; height: 40
            anchors.left: openCashboxButton.right; anchors.leftMargin: 10
            anchors.top: openCashboxButton.top
            operation: "锁定系统"
            textSize: 16

            onOperate: {
                loadLogin()
            }
        }

        Button {
            id: settingsButton
            width: 395; height: 40
            anchors.left: parent.left
            anchors.top: openCashboxButton.bottom; anchors.topMargin: 10
            operation: "系统设置"
            textSize: 16

            onOperate: {
                loadStart()
            }
        }

        Button {
            id: logoutButton
            width: 395; height: 40
            anchors.left: settingsButton.right; anchors.leftMargin: 10
            anchors.top: settingsButton.top
            operation: "注销系统"
            textSize: 16
        }

        Button {
            id: changeDiscountButton
            width: 395; height: 40
            anchors.left: parent.left
            anchors.top: settingsButton.bottom; anchors.topMargin: 10
            operation: "修改折扣"
            textSize: 16
        }

        Button {
            id: accountingButton
            width: 395; height: 40
            anchors.left: changeDiscountButton.right; anchors.leftMargin: 10
            anchors.top: changeDiscountButton.top
            operation: "核算收入"
            textSize: 16
        }

        Button {
            id: testButton
            width: 395; height: 40
            anchors.left: parent.left
            anchors.top: changeDiscountButton.bottom; anchors.topMargin: 20
            operation: "设备测试"
            textSize: 16
        }

        Button {
            id: printButton
            width: 395; height: 40
            anchors.left: testButton.right; anchors.leftMargin: 10
            anchors.top: testButton.top
            operation: "打印收据"
            textSize: 16
        }

        Button {
            id: analyseButton
            width: 395; height: 40
            anchors.left: parent.left
            anchors.top: testButton.bottom; anchors.topMargin: 10
            operation: "销售分析"
            textSize: 16
        }

        Button {
            id: othersButton
            width: 395; height: 40
            anchors.left: analyseButton.right; anchors.leftMargin: 10
            anchors.top: analyseButton.top
            operation: "其他功能"
            textSize: 16
        }
    }

    Rectangle {
        id: foreground
        width: parent.width; height: parent.height
        color: "black"
        opacity: 0.6
        visible: false
        MouseArea {
            id: mouseArea
            anchors.fill: parent
        }
    }

    Item {
        id: cashDialog
        width: 600; height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        y: 800
        Connections {
            target: keyBoard
            onTextUpdatesignal: {
                 display.text = Global.gtextIn
            }
            onCancelsignal: {
                cashDialog.y = 800
                keyboardRect.y = 800
                foreground.visible = false
                display.text = "0.0"
                Global.gtextIn =""
            }
            onFinishsignal: {
                cashDialog.y = 800
                keyboardRect.y = 800
                //foreground.visible = false
                Global.gtextIn =""
                keyboardRect2.y = 400
                dealyTimer.running = true
            }
        }

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }

        Rectangle {
            id: cashDialogRect
            width: 600; height: 400
            color: "black"
            smooth: true
            opacity: 0.8
            radius: 10
        }

        Rectangle {
            id: cashDialogHeader
            width: parent.width; height: 60
            color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0;
                               color: Qt.rgba(0.5,0.5,0.5,0.5) }
                GradientStop { position: 0.7; color: "black" }
                GradientStop { position: 1.0; color: "black" }
            }

            Text {
                id: cashDialogTitle
                text: "现金收取"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
                font.bold: true
                anchors.centerIn: parent
                color: "white"
            }
        }

        Text {
            id: totalDueTitle
            text: "应收金额"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cashDialogHeader.bottom; anchors.topMargin: 40
        }

        Text {
            id: totalDue
            text: totalText.text
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 56
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cashDialogHeader.bottom; anchors.topMargin: 70
        }

        Text {
            id: tenderedTitle
            text: "实收金额"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cashDialogHeader.bottom; anchors.topMargin: 150
        }

        Display2 {
            id: display
            width: 230
            height: 80
            color: "black"
            radius: 10
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cashDialogHeader.bottom; anchors.topMargin: 180
            text: "0.0"

            gradient: Gradient {
                GradientStop { position: 0.0;
                               color: Qt.rgba(0.5,0.5,0.5,0.5) }
                GradientStop { position: 0.7; color: "black" }
                GradientStop { position: 1.0; color: "black" }
            }
        }

        Timer {
            id: dealyTimer
            interval: 50; running: false; //repeat: true
            onTriggered: {
                changeDialog.y = 0
            }
        }
    }

    Item {
        id: changeDialog
        width: 600; height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        y: 800

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }

        Connections {
            target: keyBoard2
            onCancelsignal: {
                changeDialog.y = 800
                keyboardRect2.y = 800
                foreground.visible = false
                display.text = "0.0"
            }
        }

        Rectangle {
            id: changeDialogRect
            width: 600; height: 400
            color: "black"
            smooth: true
            opacity: 0.8
            radius: 10
        }

        Rectangle {
            id: changeDialogHeader
            width: parent.width; height: 60
            color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0;
                               color: Qt.rgba(0.5,0.5,0.5,0.5) }
                GradientStop { position: 0.7; color: "black" }
                GradientStop { position: 1.0; color: "black" }
            }

            Text {
                id: changeDialogTitle
                text: "现金找零"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
                font.bold: true
                anchors.centerIn: parent
                color: "white"
            }
        }

        Text {
            id: tendered2Title
            text: "实收金额:"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.left: totalDue2Title.left
            anchors.top: changeDialogHeader.bottom; anchors.topMargin: 20
        }

        Text {
            id: tendered2
            text: display.text
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            color: "white"
            anchors.right: totalDue2.right
            anchors.bottom: tendered2Title.bottom
        }

        Text {
            id: totalDue2Title
            text: "应收金额:"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.left: parent.left; anchors.leftMargin: 220
            anchors.top: changeDialogHeader.bottom; anchors.topMargin: 60
        }

        Text {
            id: totalDue2
            text: totalDue.text
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            color: "white"
            anchors.right: parent.right; anchors.rightMargin: 220
            anchors.bottom: totalDue2Title.bottom
        }

        Text {
            id: changeTitle
            text: "找 零"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: changeDialogHeader.bottom; anchors.topMargin: 120
        }

        Text {
            id: change
            text: tendered2.text - totalDue2.text
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 66
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: changeDialogHeader.bottom; anchors.topMargin: 140
        }

        Button {
            id: printReceiptButton
            width: 260; height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: changeDialogHeader.bottom; anchors.topMargin: 260
            operation: "打印收据"
            textSize: 18
            color: "green"

            onOperate: {
                Global.renderMoney = totalDue2.text
                Global.giveMoney = tendered2.text
                Global.changeMoney = change.text
                printOrder.printMenutoForeground(Global.orderNO,Global.renderMoney,Global.giveMoney,Global.changeMoney)
                changeDialog.y = 800
                keyboardRect2.y = 800
                foreground.visible = false
                display.text = "0.0"
               //CalcEngine.lastOp = ""
               //CalcEngine.realText = ""
                orderManager.payOrder(Global.orderNO)
                //Global.orderNO = -1
                Global.oldorderNO = ""
                Global.gorderIndex = 0
                orderList.loadOrderList()
                itemList.loadItemsData()
                server.sendRefreshUiSignal()
            }
        }
    }

    Item {
        id: cardDialog
        width: 600; height: 400
        anchors.horizontalCenter: parent.horizontalCenter
        y: 800

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }

        Rectangle {
            id: cardDialogRect
            width: 600; height: 400
            color: "black"
            smooth: true
            opacity: 0.8
            radius: 10
        }

        Rectangle {
            id: cardDialogHeader
            width: parent.width; height: 60
            color: "black"

            gradient: Gradient {
                GradientStop { position: 0.0;
                               color: Qt.rgba(0.5,0.5,0.5,0.5) }
                GradientStop { position: 0.7; color: "black" }
                GradientStop { position: 1.0; color: "black" }
            }

            Text {
                id: cardDialogTitle
                text: "刷卡支付"
                font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 20
                font.bold: true
                anchors.centerIn: parent
                color: "white"
            }
        }

        Text {
            id: totalDue3Title
            text: "应收金额"
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 16
            font.bold: true
            color: "grey"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cardDialogHeader.bottom; anchors.topMargin: 20
        }

        Text {
            id: total3Due
            text: totalDue.text
            font.family: "微软雅黑"
            smooth: true
            font.pixelSize: 56
            color: "white"
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cardDialogHeader.bottom; anchors.topMargin: 40
        }

        Button {
            id: printReceipt2Button
            width: 260; height: 50
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: cardDialogHeader.bottom; anchors.topMargin: 260
            operation: "打印收据"
            textSize: 18
            color: "green"

            onOperate: {
                cardDialog.y = 800
                foreground.visible = false
            }
        }
    }

    Rectangle {
        id: keyboardRect
        width: parent.width; height: 368
        color: "#343434";
        y: 800

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }

        Image { source: "qrc:/images/stripes.png"; fillMode: Image.Tile; anchors.fill: parent; opacity: 0.3 }

        KeyBoard {
            id: keyBoard
            anchors.centerIn: parent
        }
    }

    Rectangle {
        id: keyboardRect2
        width: parent.width; height: 368
        color: "#343434";
        y: 800

        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }
        Image { source: "qrc:/images/stripes.png"; fillMode: Image.Tile; anchors.fill: parent; opacity: 0.3 }

        KeyBoard {
            id: keyBoard2
            anchors.centerIn: parent
        }
    }

    Item {
        id: addMenuItem
        width: 1280; height: 278
        y:800
        opacity: 1
        Behavior on y {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint }
        }
        Rectangle{
            width: 1280; height: 278
            opacity: 1
            color:"black"
        }

        AddMenuGrid{
            id: addMenuGrid
            anchors.left: parent.left; anchors.leftMargin: 10
            anchors.top: parent.top; anchors.topMargin: 15
        }

        Rectangle{
        id: addTitle
        width: 1280; height: 50
        anchors.right: parent.right; anchors.rightMargin: 0
        anchors.bottom: parent.bottom; anchors.bottomMargin: 0

        Rectangle {
            id: titleBackground
            anchors.fill: addTitle; radius: 0; color: "black"; opacity: 1
            gradient: Gradient {
                GradientStop { position: 0.0;
                               color: Qt.rgba(0.8,0.8,0.8,0.8) }
                GradientStop { position: 0.1; color: "black" }
                GradientStop { position: 1.0; color: "black" }
                    }
               }
        SumCategoryList{
             id: sumCategoryList
             width: 1280-addBackButton.width; height: 48
             anchors.left: parent.left
             anchors.bottom: parent.bottom
             Component.onCompleted: {
                 sumCategoryList.getCategoryList();
                 sumCategoryList.getCategoryModel();
                 //sumCategoryList.getfistCategory();
             }
        }
        Image {
            id: addBackButton
            source: "qrc:/images/left-Yellow.png"
            width: 60; height:50
            anchors.right: parent.right; anchors.rightMargin: 0
            anchors.bottom: parent.bottom; anchors.bottomMargin: 0
            MouseArea {
                anchors.fill: parent
                onPressed: {
                    addBackButton.source = "qrc:/images/left-Green.png"
                }
                onReleased: {
                    addBackButton.source = "qrc:/images/left-Yellow.png"
                    addMenuItem.y = 800
                    rightbord.x = 630
                    leftbord.x = 15
                 //  addMenuGrid.saveSumMenuData()
                 //   CalcEngine.addMenuBack()
                }
             }
           }
        }
     }

    OrderDialogRect{
        id: newOrderDialog
        x: 1280;y:70
        property string title: "新建订单"
        property int orderNo: 1
        property string seat: ""
        property int discountNo: 3
        property int orderRectNo: 1
        Behavior on x {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint}
        }
        onToMaincancel:{
            newOrderDialog.x = 1280
            detailRect.x = 630
            rightbord.x = 630
        }
        onTonewMainfinish:{
            newOrderDialog.x = 1280
            detailRect.x = 630
            rightbord.x = 630
        }
    }

    OrderDialogRect{
        id: modifyOrderDialog
        x: 1280;y:70
        property string title: "修改订单"
        property int orderNo: 1
        property string seat: ""
        property int discountNo: 3
        property int orderRectNo: 2
        Behavior on x {
            NumberAnimation { duration: 400; easing.type: Easing.OutQuint }
        }
        onToMaincancel:{
            modifyOrderDialog.x = 1280
            detailRect.x = 630
            rightbord.x = 630
        }
        onTomodifyMainfinish:{
            modifyOrderDialog.x = 1280
            detailRect.x = 630
            rightbord.x = 630
        }
    }
}





