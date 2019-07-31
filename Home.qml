import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtPositioning 5.2
import QtLocation 5.3

import QtWebView 1.0

import QtQuick.Controls.Material 2.0

import Qt.labs.settings 1.0


import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.1
import QtQuick.Window 2.0


import "home.js" as HOME
import "main.js" as MAIN
import SortFilterProxyModel 0.1




Page {
    id: root

    clip: true

//    background: Image {
//        id: backgroungPic
//        fillMode: Image.PreserveAspectFit
//        source: "./images/background.png"
//    }

    property bool _BACK_VISIBLE: toolButtonBack.visible

    property var _MAIN_HEADING: 'Your Discounts'

    property var _ORG_HEADING: ''
    property var _OFFEREE_HEADING: ''
    property var _OFFERER_HEADING: ''

    property var _ORG_PICTURE: ''

    property var _SELECTED_OFFERER_MODEL: ''

    signal goBack();

    onGoBack: {
        if(stackViewSecondary.depth > 1) {
            stackViewSecondary.pop();
            gmapPage.loadMap(false);
            return
        }
        stackViewSecondary.clear()
        stackViewSecondary.visible = false
    }



    Component.onCompleted: {

        stackViewSecondary.pop()

    }




    ProgressBar {
        indeterminate: true
        anchors.centerIn: parent
        visible: modelOffer.count < 1? true: false
    }


//    Dialog {
//        id: dialogProfile
//        height: parent.height; width: parent.width
//    }






    header: ToolBar {

        Material.background: "#c2d52e"

        RowLayout {
            anchors.fill: parent
            spacing: 30

            ToolButton {
                id: toolButtonBack
                visible: stackViewSecondary.visible  ? true: false
                contentItem: Text {
                    horizontalAlignment: Image.AlignHCenter
                    verticalAlignment: Image.AlignVCenter
                    text: '\uf060'
                    color: 'white'
                    font.family: fontAwesome.name
                    font.pointSize: 23
                }
                onClicked: {
                    if(stackViewSecondary.depth > 1) {
                        stackViewSecondary.pop();
                        gmapPage.loadMap(false);
                        return
                    }
                    stackViewSecondary.clear()
                    stackViewSecondary.visible = false
                }
            }

            ToolButton {
                contentItem: Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 23
                    color: 'white'
                    visible: stackViewSecondary.visible ? false : true

                    text: flipable.flipped ? '\uf00a' : '\uf041'
                }
                onClicked: {
                    flipable.flipped = !flipable.flipped
                    gmapPage.loadMap(flipable.flipped)
                    if (flipable.flipped) {
                        gmapPage.loadPositions(filteredOrgModel);
                    }
                }

            }

            Label {
                id: titleLabel
                text: _MAIN_HEADING
                font.pixelSize: 20
                color: 'white'
                elide: Label.ElideRight
                horizontalAlignment: Qt.AlignHCenter
                verticalAlignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }

            ToolButton {
                visible:  !flipable.flipped && stackViewSecondary.depth == 0
                contentItem: Text {
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    font.pointSize: 23
                    color: 'white'
                    text: '\uf142'
                }
                onClicked: {
                    //settingsPopup.open()
                    optionsMenu.open()
                }


            }
        }
    }

    SortFilterProxyModel {
        id: filteredOrgModel
        sourceModel: modelOffer
        filterRoleName: "category"
        filterCaseSensitivity: Qt.CaseInsensitive

    }

    SortFilterProxyModel {
        id: filteredOffererModel
        sourceModel: modelOfferDuplicates
        filterRoleName: "uid"
        filterCaseSensitivity: Qt.CaseInsensitive
    }


    SortFilterProxyModel {
        id: filteredOffereeModel
        sourceModel: modelOfferDuplicates
        filterRoleName: "bankOffering"
        filterCaseSensitivity: Qt.CaseInsensitive

    }

    SortFilterProxyModel {
        id: filteredOffereeModelForCompany
        sourceModel: modelOfferDuplicates
        filterRoleName: "companyOffering"
        filterCaseSensitivity: Qt.CaseInsensitive

    }

    SortFilterProxyModel {
        id: filteredOffereeModelForUs
        sourceModel: modelOfferDuplicates
        filterRoleName: "ourOffering"
        filterCaseSensitivity: Qt.CaseInsensitive

    }

    ListModel {
        id: intermediary
    }



    Flipable {
        id: flipable

        front: pageFront
        back:  gmapPage

        GMapPage {
            id: gmapPage
            height: pageFront.height
            width: pageFront.width
        }


        width: pageFront.width
        height: pageFront.height

        property bool flipped: false

        transform: Rotation {
            id: rotation
            origin.x: flipable.width/2
            origin.y: flipable.height/2
            axis.x: 0; axis.y: 1; axis.z: 0     // set axis.y to 1 to rotate around y-axis
            angle: 0    // the default angle
        }

        states: State {
            name: "back"
            PropertyChanges { target: rotation; angle: 180 }
            when: flipable.flipped
        }

        transitions: Transition {
            NumberAnimation { target: rotation; property: "angle"; duration: 300 }
        }

        MouseArea {
            anchors.fill: parent
            onClicked: flipable.flipped = !flipable.flipped
        }


    }

    //    MapPage {
    //        id: mapRect
    //        height: pageFront.height
    //        width: pageFront.width
    //    }





    Rectangle {
        id: pageFront
        color: 'transparent'
        width: childrenRect.width
        height: childrenRect.height

        Flickable {
            id: flickableCategory
            width: parent.width
            height: 50
            clip: true
            contentWidth: modelCategory.count * 150

            Material.background: 'transparent'


            GMapPage {
                id: gmapPageSub
                height: pageFront.height
                width: pageFront.width

                Component.onCompleted: {
                    gmapPageSub.loadMap(false)
                }
            }

            TabBar {
                id: mainBar
                clip: true


                Repeater {
                    id: repeaterCategory
                    model: modelCategory



                    TabButton {
                        text: name
                        width: 130
                        onClicked:  {
                            titleLabel.text = name + " Offers"
                            filteredOrgModel.filterPattern = name === 'All' ? '' : name
                        }


                    }

                }
            }

        }


        Item {
            height: 30
            width: parent.width


            property bool refresh: state == "pulled" ? true : false

            y: -gridViewOrganization.contentY - height

            Row {
                spacing: 6
                height: childrenRect.height
                anchors.centerIn: parent

                Label {
                    id: arrow
                    text: '\uf0aa'
                    font.family: fontAwesome.name
                    font.pointSize: 20
                    transformOrigin: Item.Center
                    Behavior on rotation { NumberAnimation { duration: 200 } }
                }

                Text {
                    id: label
                    anchors.verticalCenter: arrow.verticalCenter
                    text: "Pull to refresh...    "
                    font.pixelSize: 18
                    color: "#999999"
                }
            }

            states: [
                State {
                    name: "base"; when: gridViewOrganization.contentY >= -100
                    PropertyChanges { target: arrow; rotation: 180 }
                },
                State {
                    name: "pulled"; when: gridViewOrganization.contentY < -100
                    PropertyChanges { target: label; text: "Release to refresh..." }
                    PropertyChanges { target: arrow; rotation: 0 }
                }
            ]
            onRefreshChanged: {
                //              MAIN.startFetch()
                if (state == 'base' && filteredOrgModel.count > 0) {
                    filteredOffereeModel.clear()
                    filteredOffereeModelForCompany.clear()
                    filteredOffererModel.clear()
                    filteredOrgModel.clear()

                    modelBank.clear()
                    modelCategory.clear()
                    modelCompany.clear()
                    modelOffer.clear()
                    modelOfferCollection.clear()
                    modelOfferDuplicates.clear()
                    modelOrganization.clear()

                    MAIN.startFetch(settings._LANGUAGE)
                }
            }

        }

        //    Button {
        //        text: 'test'
        //        onClicked: {
        //            console.log(JSON.stringify(modelOrganization.get(0)))
        //            console.log(JSON.stringify(filteredOrgModel.count))
        //            console.log(JSON.stringify(modelCategory.get(0)))
        //        }
        //    }

        SwipeView {
            id: swipView
            clip: true
            anchors.top: flickableCategory.bottom
            width: root.width
            height: root.height - 100

            Material.background: 'transparent'





            Item {
                TextField {
                    id: searchBox
                    placeholderText: 'Search...'
                    width: parent.width
                    anchors.horizontalCenter: parent.horizontalCenter
                    onTextChanged: {
                        if (searchBox.text == '') {
                            filteredOrgModel.filterRoleName = 'category'
                            filteredOrgModel.filterPattern = ''
                        }

                        filteredOrgModel.filterRoleName = 'name'
                        filteredOrgModel.filterPattern = searchBox.text
                    }
                }

                GridView {
                    id: gridViewOrganization
                    anchors.top: searchBox.bottom
                    height: parent.height
                    enabled: modelOffer.count < 1? false: true
                    opacity: modelOffer.count < 1? 0.3: 1

                    model: filteredOrgModel
                    width: parent.width

                    cellWidth: (root.width / 3)
                    cellHeight: 130

                    delegate: Rectangle {
                        width: (root.width / 3) - 3
                        height: 120
                        radius: 4
                        border.color: 'silver'

                        color: 'white'





                        Column {
                            width: parent.width
                            topPadding: 4
                            spacing: 5

                            Image {
                                id: imageOrganization
                                fillMode: Image.PreserveAspectFit
                                anchors.horizontalCenter: parent.horizontalCenter
                                height: parent.height * .7
                                width: parent.width - 5



                                Component.onCompleted: {
                                    if (picture!== '') {
                                        imageOrganization.source =  savePictures('Organization/' + uid + ".png", picture, function(source){
                                            console.log('THIS ' + imageOrganization.Error )
                                            if (imageOrganization.Error)
                                                imageOrganization.source = 'qrc://images/logo.png'
                                        })
                                    }
                                    else {
                                        imageOrganization.source = './images/logo.png'
                                    }

                                }

                                Rectangle {
                                    id: lblOfferPercent
                                    height: 20 ; width: childrenRect.width + 8
                                    anchors {right: parent.right; bottom: parent.bottom}
                                    radius: 3
                                    color: Material.accent
                                    // opacity: .7

                                    Label {
                                        text: offerPercent!=='' ?  offerPercent + '%' : offerAmount !== ''?  offerAmount + ' SAR' : ''
                                        color: 'white'
                                        // anchors {horizontalCenter: parent.horizontalCenter}
                                    }
                                }

                            }

                            Rectangle {
                                id: seperationLine
                                height: 1; color: 'silver'; width: parent.width - 15
                                anchors.horizontalCenter: parent.horizontalCenter
                            }

                            Label{
                                text: name
                                width: parent.width-10
                                anchors.horizontalCenter: parent.horizontalCenter
                                elide: Text.ElideMiddle
                                horizontalAlignment: Text.AlignHCenter
                                font.family: fontLato.name
                            }
                        }

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                filteredOffererModel.filterPattern = uid === '' ? 'xxxxxxx' : uid
                                _ORG_HEADING = name
                                _ORG_PICTURE = picture!=='' ? savePictures('Organization/' + uid + ".png", picture, function(){}) : './images/logo.jpg'


                                stackViewSecondary.push('qrc:/Offeree.qml')
                                stackViewSecondary.visible = true
                            }
                        }

                        //                        Flow {
                        //                            width: parent.width; height: childrenRect.height
                        //                            anchors.horizontalCenter: parent.horizontalCenter
                        //                            anchors.top: imageOrganization.bottom
                        //                            spacing: 4
                        //                            padding: 3

                        //                            Repeater {
                        //                                model: 4

                        //                                Rectangle {
                        //                                    radius: 5
                        //                                    height: 10; width: imageOrganization.width /2
                        //                                    color: '#e91e63'
                        //                                    Label {
                        //                                        anchors.horizontalCenter:  parent.horizontalCenter
                        //                                        font.pixelSize: 9
                        //                                        color: 'white'

                        //                                        text: 'Bank ' + index
                        //                                    }

                        //                                    // Offerer Mouse Area
                        //                                    MouseArea {
                        //                                        anchors.fill: parent
                        //                                        onClicked: {
                        //                                            stackViewSecondary.push('qrc:/Offerer.qml')
                        //                                            stackViewSecondary.visible = true

                        //                                        }
                        //                                    }
                        //                                }
                        //                            }
                        //                        }



                    }

                    ScrollBar.vertical: ScrollBar { }

                }
            }

        }

    }

    Menu {
        id: optionsMenu
        x: parent.width - width
        transformOrigin: Menu.TopRight

        MenuItem {
            text: settings._LANGUAGE == 'en'? 'Profile' : "الملف الشخصي"
            onTriggered: {
                stackViewSecondary.push('qrc:/Profile.qml')
                stackViewSecondary.visible = true
            }
        }
        MenuItem {
            text: settings._LANGUAGE == 'en'? 'العربية' : 'English'
            onTriggered: {
                settingsPopup.close()

                filteredOffereeModel.clear()
                filteredOffereeModelForCompany.clear()
                filteredOffererModel.clear()
                filteredOrgModel.clear()

                modelBank.clear()
                modelCategory.clear()
                modelCompany.clear()
                modelOffer.clear()
                modelOfferCollection.clear()
                modelOfferDuplicates.clear()
                modelOrganization.clear()


                MAIN.startFetch(settings._LANGUAGE == 'en'? 'ar' : 'en')
                settings._LANGUAGE = settings._LANGUAGE == 'en'? 'ar' : 'en'

            }
        }
        MenuItem {
            text: settings._LANGUAGE == 'en'? "Logout" : 'خروج'
            onTriggered: {
                userLogAdd('thisUser', 'Logout')
                settingsPopup.close()

                filteredOffereeModel.clear()
                filteredOffereeModelForCompany.clear()
                filteredOffererModel.clear()
                filteredOrgModel.clear()

                modelCategory.clear()
                modelOffer.clear()
                modelOfferCollection.clear()
                modelOfferDuplicates.clear()
                modelOrganization.clear()

                loginPageEssentials()

                stackViewMain.push(loginPage) // to be replaced by  StackView.replace(<URL>)

            }
        }
    }

    Popup {
        id: settingsPopup
        width: root.width/2
        height: root.height * .7

        modal: true
        focus: true

        x: root.width - width

        ColumnLayout {

            Button {
                text: 'Profile'
                width: settingsPopup.width
                Material.background: 'transparent'
                onClicked: {
                    settingsPopup.close()
                }

            }

            Button {
                text: settings._LANGUAGE == 'en'? 'Arabic' : 'English'
                width: settingsPopup.width
                Material.background: 'transparent'
                onClicked: {
                    settingsPopup.close()

                    filteredOffereeModel.clear()
                    filteredOffereeModelForCompany.clear()
                    filteredOffererModel.clear()
                    filteredOrgModel.clear()

                    modelBank.clear()
                    modelCategory.clear()
                    modelCompany.clear()
                    modelOffer.clear()
                    modelOfferCollection.clear()
                    modelOfferDuplicates.clear()
                    modelOrganization.clear()


                    MAIN.startFetch(settings._LANGUAGE == 'en'? 'ar' : 'en')
                    settings._LANGUAGE = settings._LANGUAGE == 'en'? 'ar' : 'en'

                }

            }

            Button {
                text: 'Logout'
                width: settingsPopup.width
                Material.background: 'transparent'
                onClicked: {
                    userLogAdd('thisUser', 'Logout')
                    settingsPopup.close()

                    filteredOffereeModel.clear()
                    filteredOffereeModelForCompany.clear()
                    filteredOffererModel.clear()
                    filteredOrgModel.clear()

                    modelCategory.clear()
                    modelOffer.clear()
                    modelOfferCollection.clear()
                    modelOfferDuplicates.clear()
                    modelOrganization.clear()

                    stackViewMain.push(loginPage) // to be replaced by  StackView.replace(<URL>)

                }

            }
        }

    }



    StackView {
        id: stackViewSecondary
        visible: false
        anchors.centerIn: parent
        width: parent.width
        height: parent.height
    }





}
