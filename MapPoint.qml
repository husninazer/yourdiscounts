import QtQuick 2.5
import QtLocation 5.3
import QtPositioning 5.2
import QtQuick.Controls 2.0


MapQuickItem {
    id: marker
    property variant _coordinate: QtPositioning.coordinate(11.1391, 75.9130)
    property var _uid: ''
    property var _title: ''
    property var _picture: ''
    property var _offer: ''
    property bool showAll: mapMain.zoomLevel < 13 ? false : true

    signal loadPicture()

    anchorPoint.x: markerDelegate.width / 2
    anchorPoint.y: markerDelegate.height

    coordinate: _coordinate

    sourceItem: Rectangle {
        id: markerDelegate
        width: 30; height: 40; color: 'transparent'; radius: 10
         Image { id: imageLarge; anchors.fill: parent; source: "./images/mapPoint.png"; visible: !showAll; fillMode: Image.PreserveAspectFit }

        Column {
            width: parent.width
            anchors.top: imageLarge.bottom

            Image{
                id: imageSmall
                width: 50 ; height: 50 ;

                anchors.horizontalCenter: parent.horizontalCenter
                visible: showAll

                MouseArea {
                    anchors.fill: parent
                    onClicked:  {
                        filteredOffererModel.filterPattern = _uid === '' ? 'xxxxxxx' : _uid
                        _ORG_HEADING = _title
                        _ORG_PICTURE = _picture!=='' ? savePictures('Organization/' + _uid + ".png", _picture, function(){}) : './images/logo.jpg'


                        stackViewSecondary.push('qrc:/Offeree.qml')
                        stackViewSecondary.visible = true
                    }
                }

            }
            Row {
                anchors.horizontalCenter: parent.horizontalCenter
                height: 20
                spacing: 10

                Label {
                    text: _title
                    font.bold: true
                    visible: mapMain.zoomLevel > 10 ? true : false
                }

                Label {
                    text: _offer
                    font.bold: true
                    visible: mapMain.zoomLevel > 10 ? true : false
                }
            }
        }
    }

    onLoadPicture:  {
        imageSmall.source =  savePictures('Organization/' + _uid + ".png", _picture, function(source){
            imageSmall.source = source
        })
    }
}


