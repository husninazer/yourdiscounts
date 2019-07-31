
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


import QtQuick.Controls.Material 2.0



Page {
    id: root

    signal loadEss(var pageHeading, var pagePicture)

    onLoadEss: {
        lblOrgHeading.text = pageHeading
        imageOfferee.source = pagePicture
    }

    Flickable {
        anchors.fill: parent
        contentHeight: colList.height * 2

        Label {
            id: lblOrgHeading
            text: _ORG_HEADING
            topPadding: 20
            font.pointSize: 17
            font.family: fontLato.name
            anchors.top: parent.top
            anchors.horizontalCenter: parent.horizontalCenter
        }

        Image {
            id: imageOfferee
            anchors.top: lblOrgHeading.bottom
            fillMode: Image.PreserveAspectFit
            width: root.width * .6
            height: width
            anchors.horizontalCenter: parent.horizontalCenter
            source: _ORG_PICTURE !== '' ? _ORG_PICTURE : './images/logo.jpg'

        }

        ColumnLayout {
            id: colList
            anchors.top: imageOfferee.bottom; anchors.topMargin: 20
            width: parent.width
            spacing: 30

            Label {
                anchors.horizontalCenter: parent.horizontalCenter
                text: 'Offer Providers'
            }


            Flow {

                width: root.width

                spacing: 5
                topPadding: 10
                leftPadding: 10


                Repeater {
                    id: repeaterOfferer
                    model: filteredOffererModel


                    Column {

                        Image {
                            id: imageBank
                            height: 70
                            width: parent.width - 5
                            anchors.horizontalCenter: parent.horizontalCenter
                            fillMode: Image.PreserveAspectFit

                            Component.onCompleted:  {

                                if(bankOffering == '') return

                                imageBank.source =  savePictures('Banks/' + getBankObj(bankOffering).uid + ".png", getBankObj(bankOffering).picture, function(source){
                                    imageBank.source = source
                                })
                            }

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (ourOffering === "true") {
                                        _OFFERER_HEADING = 'Our Offer'
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModelForUs
                                        filteredOffereeModelForUs.filterPattern = "true"
                                    }

                                    if (companyOffering !== "") {
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModelForCompany
                                        filteredOffereeModelForCompany.filterPattern = companyOffering
                                        _OFFERER_HEADING = getCompanyObj(companyOffering).name
                                    }

                                    if (bankOffering !== '') {
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModel
                                        filteredOffereeModel.filterPattern = bankOffering
                                        _OFFERER_HEADING = getBankObj(bankOffering).name
                                    }

                                    stackViewSecondary.push('qrc:/Offerer.qml')
                                }
                            }
                        }

                        Rectangle {
                            id: rectTop
                            width: (root.width /2) - 18
                            height: 25
                            radius: 3
                            anchors.leftMargin: 20


                            Label {
                                id: names
                                text: bankOffering!== ''?  getBankObj(bankOffering).name :
                                                          companyOffering!== '' ?  getCompanyObj(companyOffering).name : 'Our Offer'
                                color: 'white'
                                anchors.centerIn: parent
                                font.pointSize: 14
                            }
                            color: '#e91e63'

                            MouseArea {
                                anchors.fill: parent
                                onClicked: {
                                    if (ourOffering === "true") {
                                        _OFFERER_HEADING = 'Our Offer'
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModelForUs
                                        filteredOffereeModelForUs.filterPattern = "true"
                                    }

                                    if (companyOffering !== "") {
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModelForCompany
                                        filteredOffereeModelForCompany.filterPattern = companyOffering
                                        _OFFERER_HEADING = getCompanyObj(companyOffering).name
                                    }

                                    if (bankOffering !== '') {
                                        _SELECTED_OFFERER_MODEL = filteredOffereeModel
                                        filteredOffereeModel.filterPattern = bankOffering
                                        _OFFERER_HEADING = getBankObj(bankOffering).name
                                    }


                                    stackViewSecondary.push('qrc:/Offerer.qml')
                                }
                            }
                        }
                        Rectangle {
                            width: (root.width /2) - 18
                            height: 25
                            radius: 3
                            anchors.leftMargin: 20
                            Label {
                                text: offerPercent!=='' ? 'Offer: ' + offerPercent + '%' : offerAmount !== ''? 'Offer: ' + offerAmount + ' SAR' : ''
                                color: 'white'
                                anchors.centerIn: parent
                                font.pointSize: 13
                            }
                            color: '#1076b1'
                        }
                        Rectangle {
                            width: (root.width /2) - 18
                            height: 25
                            radius: 3
                            anchors.leftMargin: 20
                            Label {
                                text: 'Valid Until ' +  expiryDate.split('-')[2] + '/' + expiryDate.split('-')[1] + '/' + expiryDate.split('-')[0]
                                color: '#1076b1'
                                width: parent.width
                                anchors.centerIn: parent
                                font.pointSize: 13
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                            }
                        }

                        Rectangle {
                            id: seperationLine
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: 1
                            width: parent.width - 5
                            color: 'silver'
                        }

                        Rectangle {
                            width: (root.width /2) - 18
                            height: 25
                            radius: 3
                            color: 'transparent'
                            anchors.leftMargin: 20
                            Label {
                                text: '\uf08e Offer Link'
                                color: '#1076b1'
                                width: parent.width
                                anchors.centerIn: parent
                                font.pointSize: 13
                                font.underline: true
                                font.family: fontAwesome.name
                                wrapMode: Text.WrapAtWordBoundaryOrAnywhere
                                horizontalAlignment: Text.AlignHCenter
                            }

                            MouseArea {
                                anchors.fill: parent

                                onClicked: {
                                    Qt.openUrlExternally(offerLink);
                                }
                            }
                        }
                    }
                }
            }

            Button {
                id: buttonMap
                text: '\uf041 Location'

                highlighted: true

                anchors.horizontalCenter: parent.horizontalCenter

                onClicked: {

                    gmapPageSub.loadPositions(filteredOffererModel);
                    gmapPageSub.loadMap(true)
                    stackViewSecondary.push(gmapPageSub)
                }
            }
        }
    }



    function gotoOfferer() {

    }
}
