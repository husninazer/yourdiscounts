
import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3


import QtQuick.Controls.Material 2.0


Page {
    id: root

    Flickable {
        anchors.fill: parent
        contentHeight: colList.height * 2

        ColumnLayout {
            id: colList
            width: parent.width
            spacing: 30


            Label {
                text: _OFFERER_HEADING === undefined ? '' : 'All Offers from ' +  _OFFERER_HEADING
                anchors.horizontalCenter: parent.horizontalCenter
                topPadding: 20
                font.pointSize: 17
            }

            GridView {
                id:gridViewOfferer
                cellWidth: parent.width / 3
                cellHeight: cellWidth + 60

                width: root.width
                height: root.height - 40

                model: _SELECTED_OFFERER_MODEL

                delegate: Rectangle {
                    border.color: 'silver'
                    width: parent.width / 3
                    height: width
                    Column {
                        width: parent.width
                        topPadding: 4
                        spacing: 5

                        Image {
                            id: imageOrganization
                            source:  picture!=='' ? savePictures('Organization/' + uid + ".png", picture) : './images/logo.jpg'
                            fillMode: Image.PreserveAspectFit
                            anchors.horizontalCenter: parent.horizontalCenter
                            height: parent.height * .7
                            width: parent.width - 10

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
                        }
                        Label{
                            text: offerPercent!=='' ? 'Offer: ' + offerPercent + '%' : offerAmount !== ''? 'Offer: ' + offerAmount + ' SAR' : ''
                            color: 'blue'
                            width: parent.width-10
                            anchors.horizontalCenter: parent.horizontalCenter
                            elide: Text.ElideMiddle
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }

//            Button {
//                id: buttonMap
//                text: 'Offers Near Me'

//                highlighted: true

//                anchors.horizontalCenter: parent.horizontalCenter

//                onClicked: {
//                    stackViewSecondary.push('qrc:/MapPage.qml')
//                }
//            }
        }
    }

}
