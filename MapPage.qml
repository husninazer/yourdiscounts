import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtPositioning 5.2
import QtLocation 5.3


import QtQuick.Controls.Material 2.0

import Qt.labs.settings 1.0



Page {
    id: root
    clip: true

    property string _GMAPS_API_KEY: 'AIzaSyAaxbpJ-1c9nM-_u25-6b67uZjdkgRWdyU'

    property MapPoint locationMarker

    signal loadPositions(var arrPositions)

    Settings {
        id: settings
        property int lastGpsLatitude: positionSource.position.coordinate.latitude
        property int lastGpsLongitude: positionSource.position.coordinate.longitude
    }


    Component.onCompleted: {

        //        if(mobileDevice.locationProviders().indexOf('GPS') === -1 ){
        //            mobileDevice.openLocationSettings()
        //           // positionSource.update()
        //        }
        mapMain.center = positionSource.valid  ? positionSource.position.coordinate : QtPositioning.coordinate(settings.lastGpsLatitude, settings.lastGpsLongitude)

    }

    onLoadPositions: {
        drawMapItems(arrPositions)

    }

    PositionSource {
        id: positionSource
        updateInterval: 1000
        active: true

        onPositionChanged: {
            var coord = positionSource.position.coordinate;
            console.log("Coordinate:", coord.longitude, coord.latitude);

        }

    }



    Map {
        id: mapMain
        anchors.fill: parent

        activeMapType: supportedMapTypes[7]

        plugin:  Plugin {
            name: "osm"
            PluginParameter { name: "osm.mapping.copyright"; value: "BuckleBerry" }
            PluginParameter { name: "osm.mapping.host"; value: "http://c.tile.thunderforest.com/transport/" }
        }

        zoomLevel: 12

        gesture.enabled: true






        MapQuickItem {
            id: mapQuickItem

            coordinate: positionSource.position.coordinate

//            coordinate {
//                latitude: 24.793
//                longitude: 46.713
//            }

            anchorPoint.x: gpsDelegte.width / 2
            anchorPoint.y: gpsDelegte.height / 2

            sourceItem:
                Rectangle {
                id: gpsDelegte
                width: 15; height: width; color: '#4285f4'; radius: width

                Rectangle { width: 2;height: 2; radius: 2; anchors.centerIn: parent }

                SequentialAnimation on opacity {
                    loops: Animation.Infinite
                    PropertyAnimation { to: 1 ; duration: 500 }
                    PropertyAnimation { to: 0 ; duration: 500 }
                }
            }
        }



        Rectangle {
            height: 30
            width: 30
            color: 'transparent'

            anchors.right: parent.right
            anchors.top: parent.top; anchors.topMargin: 20

            Label {
                anchors.centerIn: parent
                font.family: fontAwesome.name
                font.pointSize: 25
                text: '\uf140'

                color: Material.accent
            }

            MouseArea {
                anchors.fill: parent

                onClicked: {
                    mapMain.center = positionSource.valid  ? positionSource.position.coordinate : QtPositioning.coordinate(settings.lastGpsLatitude, settings.lastGpsLongitude)

                }
            }
        }
    }

    function drawMapItems(Arr){

        console.log("Drawing Items on MAP.....")

        mapMain.clearMapItems()

        mapMain.addMapItem(mapQuickItem)


        for(var i = 0; i < Arr.count; i++){
            var lati = Arr.get(i).locationLat
            var longi = Arr.get(i).locationLong

            var uid = Arr.get(i).uid
            var name = Arr.get(i).name
            var picture = Arr.get(i).picture
            var offer = Arr.get(i).offerPercent!==''? Arr.get(i).offerPercent + ' %': Arr.get(i).offerAmount + ' SAR'


            if (lati == '' || longi == '') continue;

            console.log("Coordinates about to add --- " + lati + ' | '+ longi)

            locationMarker = Qt.createQmlObject('MapPoint { }', mapMain)
            locationMarker._coordinate = QtPositioning.coordinate(lati, longi)

           mapMain.center = locationMarker._coordinate
            mapMain.center = positionSource.valid  ? positionSource.position.coordinate : QtPositioning.coordinate(settings.lastGpsLatitude, settings.lastGpsLongitude)

            locationMarker._uid = uid
            locationMarker._title = name
            locationMarker._picture = picture
            locationMarker._offer = offer

            locationMarker.loadPicture(uid, picture)

            mapMain.addMapItem(locationMarker)

        }
    }


}
