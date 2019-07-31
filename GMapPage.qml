import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtPositioning 5.2
import QtWebView 1.1


import QtQuick.Controls.Material 2.0

import Qt.labs.settings 1.0

import QtQuick.Dialogs 1.0


Page {
    id: root
    clip: true

    property string _GMAPS_API_KEY: 'AIzaSyAaxbpJ-1c9nM-_u25-6b67uZjdkgRWdyU'

    property string _HTML : ''

    property string _URL : "https://www.google.com/maps/embed/v1/search?key=" + _GMAPS_API_KEY + "&q=Space+Needle,Seattle+WA"

    property string _PARAMS : ''

    signal loadMap(bool toggle);

    signal loadPositions(var arrayPositions);

    Component.onCompleted: {

    }

    AnimatedImage {
        id: imgMapLoading

        anchors.centerIn:  parent
        width: parent.width/6
        height: width
        source: "./images/mapLoading.gif"

    }


    WebView {
        id: webView
        anchors.fill: parent

        anchors.centerIn: parent

        url: _URL + _PARAMS

        visible: false



        Component.onCompleted: {

          //  _URL = "http://maps.google.com/maps?q=12.927923,77.627108&z=15&output=embed"
          //  _URL = "http://mapsengine.google.com/map/embed?mid=z-BEFzFo7gdM.kYdiUKVQpQQI"

            _URL = "http://54.149.230.17:5454/gmap/#/"                  //"http://63.142.255.58:5454/gmap/#/"

            _HTML = "<body> <iframe width='100%' height='100%' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' style='border:0' src=" + _URL + _PARAMS + " allowfullscreen></iframe></body>"


            console.log(_HTML)

           // loadHtml(_HTML)

        }

    }

    Timer {
        id: timer
        interval: 1000
        onTriggered: webView.visible = true
    }

    onLoadMap: {
        if (toggle) {

            imgMapLoading.visible = true
            timer.start()
            return
        }

        webView.visible = false
        imgMapLoading.visible = false
    }

    onLoadPositions: {
        drawMapItems(arrayPositions);
    }

    function drawMapItems(Arr){

       // if (!Arr.length) return

        var params = '';
       // console.log("Drawing Items on GOOGLE MAP.....")


        for(var i = 0; i < Arr.count; i++){
            var lati = Arr.get(i).locationLat
            var longi = Arr.get(i).locationLong

            var uid = Arr.get(i).uid
            var name = Arr.get(i).name
            var picture = Arr.get(i).picture
            var offer = Arr.get(i).offerPercent!==''? Arr.get(i).offerPercent + ' ': Arr.get(i).offerAmount + ' '


            if (lati == '' || longi == '') continue;

            // example: 'McD+24.848848+46.781437+30%'
            params += name +'+'+ lati +'+'+ longi +'+'+ offer + '&';

        }

        params = params.substring(0, params.length-1)

        _PARAMS = params

       // _HTML = "<body> <iframe width='100%' height='100%' frameborder='0' scrolling='no' marginheight='0' marginwidth='0' style='border:0' src=" + _URL + _PARAMS + " allowfullscreen></iframe></body>"

        console.log(_URL + _PARAMS)

        webView.reload();

       // webView.loadHtml(_HTML);


    }





}

