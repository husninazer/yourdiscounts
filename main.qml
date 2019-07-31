import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.0

import QtQuick.Controls.Material 2.0

import QtQuick.LocalStorage 2.0

import Qt.labs.settings 1.0

import "main.js" as MAIN

import MobileDevice 0.1

import AndroidPermissions 0.1



ApplicationWindow {
    id: window
    visible: true
    width: 360
    height: 600
    title: qsTr("Your Discounts")

    property var _URL: 'http://54.149.230.17:5454'  //'http://63.142.255.58:5454'
    property var _REST_SESSION_TOKEN: '0CSG7lWa1bZnlkN3hWBJEdpjgQq8OOpu5FLMUzOZU4I'

    property var _URL_PARSE: 'http://63.142.255.58:9797'

    property var _PARSE_APPLICATION_ID: 'YOURDISCOUNTS2016'
    property var _PARSE_MASTER_KEY: 'COMPANY2016'

    property var _DB: LocalStorage.openDatabaseSync("yourDiscounts", "1.0", "The Database1", 5000000);

    property var _SELECTED_BANKS: []

    property var _USER_ID: ''
    property var _USER_NAME: ''
    property var _USER_COMPANY: ''
    property var _USER_BANKS: []

    property bool _CON: true

    property bool _IS_LOGGED_IN: true




    Component.onCompleted: {


        modelOffer.clear()

        if(isUserLoggedIn()!== '') {
            MAIN.startFetch(settings._LANGUAGE)

        }
        else loginPageEssentials();


        if(Qt.platform.os == 'linux'){
            Requisites.createDirectory('Images')
            Requisites.createDirectory('Images/Organization')
            Requisites.createDirectory('Images/Banks')
        }

        else if(Qt.platform.os == 'android'){

            if (androidPermissions.getIsMarshmallowOrAbove) {
                console.log("Marshmallow")

                androidPermissions.requestPermissions();

            }

            Requisites.createDirectory(mobileDevice.primaryStoragePath() + '/Discounts')
            Requisites.createDirectory(mobileDevice.primaryStoragePath() +'/Discounts/Images')
            Requisites.createDirectory(mobileDevice.primaryStoragePath() + '/Discounts/Images/Organization')
            Requisites.createDirectory(mobileDevice.primaryStoragePath() + '/Discounts/Images/Banks')
        }

        else if (Qt.platform.os == 'ios') {
          //  console.log("Standard PAth: " + Requisites.standardPath())

            console.log("###########################Running")
            console.log(Requisites.standardPath())
            console.log("Dir exists (ROOT): " + Requisites.isDirExists(Requisites.standardPath()))

            Requisites.createDirectory(Requisites.standardPath()+ '/Discounts')
            Requisites.createDirectory(Requisites.standardPath() +'/Discounts/Images')
            Requisites.createDirectory(Requisites.standardPath() + '/Discounts/Images/Organization')
            Requisites.createDirectory(Requisites.standardPath() + '/Discounts/Images/Banks')
        }

    }

    MobileDevice {
        id: mobileDevice
    }

    AndroidPermissions {
        id: androidPermissions
    }

    Settings {
        id: settings
        property string _LANGUAGE: 'en'
    }


    StackView {
        id: stackViewMain
        anchors.fill: parent

        Material.foreground: '#eb136e'

        clip: true
        initialItem:   isUserLoggedIn()!== ''? homePage : loginPage
    }



    ListModel {
        id: modelBank
    }

    ListModel {
        id: modelCompany
    }





    // MODELS
    ListModel {
        id: modelCategory
        ListElement {name: 'All'}

    }

    ListModel {
        id: modelOrganization
        ListElement {name: 'myhotel'; category: 'restaurant '; picture: ''; locationLat: ''; locationLong: ''}
    }

    ListModel {
        id: modelOfferCollection
        ListElement {name: 'myhotel'; category: 'restaurant '}
    }

    ListModel {
        id: modelOffer
        ListElement {uid: '';
            fid: '';
            category: '';
            name: '';
            address: '';
            picture: '';
            locationLat: '';
            locationLong: '';
            offerPercent: '';
            offerAmount: '';
            expiryDate:'';
            offerLink:'';
            bankOffering: '';
            companyOffering:  '';
            ourOffering: 'a'}
    }

    ListModel {
        id: modelOfferDuplicates
        ListElement {uid: '';
            fid: '';
            category: '';
            name: '';
            address: '';
            picture: '';
            locationLat: '';
            locationLong: '';
            offerPercent: '';
            offerAmount: '';
            expiryDate:'';
            offerLink:'';
            bankOffering: '';
            companyOffering:  '';
            ourOffering: 'a'}
    }



    Home {
        id: homePage
        visible: false
    }







    Page {
        id: loginPage
        visible: false
        clip: true
        BusyIndicator {
            id: busyIndicatorLoginPage
            visible: false
            anchors.centerIn: parent
            z: 100
        }


        Pane {
            id: paneLogin
            width: parent.width

            Column {
                width: parent.width
                topPadding: 20
                spacing: 20


                Image {
                    id: logoImage
                    anchors.horizontalCenter: parent.horizontalCenter
                    width: parent.width / 2
                    fillMode: Image.PreserveAspectFit
                    source: "qrc:/images/logoMain.png"
                }

                Label {
                    text: 'Login'
                    anchors.horizontalCenter: parent.horizontalCenter
                }
                TextField {
                    id: txtLoginUserName
                    width: parent.width - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    placeholderText: 'Username'

                }

                TextField {
                    id: txtLoginPassword
                    width: parent.width - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    echoMode: TextInput.Password
                    placeholderText: 'Password'

                }


                Button {
                    id: btnLogin
                    text: 'Login'
                    width: parent.width - 80
                    anchors.horizontalCenter: parent.horizontalCenter
                    highlighted: true

                    ToolTip.timeout: 5000

                    onClicked: {

                        //                        userLogAdd(txtLoginUserName.text, 'Login')
                        //                        stackViewMain.push(homePage)
                        //                        MAIN.startFetch(); return;

                        // remove the above 3 lines of code for production

                        if(txtLoginUserName.text === '' || txtLoginPassword.text === '') {
                            btnLogin.ToolTip.text = 'Fill in username/ password to login'
                            btnLogin.ToolTip.visible = true
                            return
                        }


                        busyIndicatorLoginPage.visible = true
                        loginUserDrupal(function(data) {
                            busyIndicatorLoginPage.visible = false
                            if(data === 'error') {
                                btnLogin.ToolTip.text = 'Check Internet Connectivity'
                                btnLogin.ToolTip.visible = true
                                return
                            }

                            if (data.length === 0) {
                                btnLogin.ToolTip.text = 'Username not Valid'
                                btnLogin.ToolTip.visible = true
                                return
                            }

                            if(data[0].field_password[0].value !== txtLoginPassword.text) {
                                btnLogin.ToolTip.text = 'Password Incorrect'
                                btnLogin.ToolTip.visible = true
                                return
                            }

                            // Get the user'sselected company if any
                            _USER_COMPANY = typeof data[0].field_company[0] !== 'undefined' ? data[0].field_company[0].value : ''

                            _USER_ID = data[0].nid[0].value


                            // Also get the user's bank if any
                            _USER_BANKS = []
                            data[0].field_banks.forEach(function(bank){
                                console.log(bank.value)
                                _USER_BANKS.push(bank.value)
                            })



                            MAIN.startFetch(settings._LANGUAGE == 'en'? 'en' : 'ar')

                            var userDetails = {
                                userId: _USER_ID,
                                userName: txtLoginUserName.text,
                                company: _USER_COMPANY,
                                banks: _USER_BANKS
                            }

                            userLogAdd(userDetails, 'Login')

                            txtLoginUserName.text = ''; txtLoginPassword.text = ''

                            stackViewMain.push(homePage)
                        })
                    }
                }
            }
        }

        Pane {
            id: paneRegister
            anchors.fill: parent
            visible: false

            BusyIndicator {
                id: busyIndicatorRegisterPage
                visible: false
                z: 100
                anchors.centerIn: parent
            }


            Flickable {
                anchors.fill: parent
                contentHeight: colList.height + 100
                Column {
                    id: colList
                    width: parent.width
                    topPadding: 10
                    spacing: 10

                    Label {
                        text: 'Register'
                        anchors.horizontalCenter: parent.horizontalCenter
                        font.pixelSize: 20
                    }


                    TextField {
                        id: txtUserName
                        placeholderText: 'Username'
                        width: parent.width - 70
                        anchors.horizontalCenter: parent.horizontalCenter

                    }


                    TextField {
                        id: txtPassword
                        placeholderText: 'Password'
                        echoMode: TextInput.Password
                        width: parent.width - 70
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    TextField {

                        id: txtConfirmPassword
                        placeholderText: 'Confirm Password'
                        echoMode: TextInput.Password
                        width: parent.width - 70
                        anchors.horizontalCenter: parent.horizontalCenter



                    }
                    //                    Label {
                    //                        text: 'Locations'
                    //                        anchors.horizontalCenter: parent.horizontalCenter
                    //                    }
                    //                    Label {
                    //                        text: 'Job'
                    //                        anchors.horizontalCenter: parent.horizontalCenter
                    //                    }

                    Label {
                        text: 'Select Bank Accounts you have'
                        topPadding: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    Repeater {
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 80

                        model: modelBank


                        delegate: CheckDelegate {

                            text: name
                            width: parent.width - 70


                            onCheckStateChanged: {

                                var id = getBankId(text);
                                if (checkState == Qt.Checked) {
                                    _SELECTED_BANKS.push(id)

                                    console.log(JSON.stringify(_SELECTED_BANKS))
                                }

                                else {
                                    _SELECTED_BANKS.forEach(function(arrayText){
                                        if (id === arrayText) removeA(_SELECTED_BANKS, id)
                                        console.log(JSON.stringify(_SELECTED_BANKS))
                                    })
                                }
                            }

                        }

                    }


                    //                    ListView {
                    //                        id: checkBoxViewBank
                    //                        width: parent.width
                    //                        clip: true
                    //                        height: childrenRect.height
                    //                        model: modelBank
                    //                        delegate: CheckBox {

                    //                            text: name
                    //                            width: parent.width - 70


                    //                            onCheckStateChanged: {
                    //                                if (checkState == Qt.Checked) {
                    //                                    _SELECTED_BANKS.push(text)

                    //                                    console.log(JSON.stringify(_SELECTED_BANKS))
                    //                                }

                    //                                else {
                    //                                    _SELECTED_BANKS.forEach(function(arrayText){
                    //                                        if (text === arrayText) removeA(_SELECTED_BANKS, text)
                    //                                        console.log(JSON.stringify(_SELECTED_BANKS))
                    //                                    })
                    //                                }
                    //                            }
                    //                        }

                    //                        BusyIndicator {
                    //                            anchors.horizontalCenter: parent.horizontalCenter
                    //                            visible: modelBank.count == 0? true: false
                    //                        }

                    //                    }

                    Label {
                        text: 'Select the Company you work in'
                        topPadding: 20
                        anchors.horizontalCenter: parent.horizontalCenter
                    }

                    ComboBox {
                        id: comboCompany
                        model: modelForCombo


                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width - 80
                        Component.onCompleted:  {
                            //                            MAIN.getData('/company', function(data) {
                            //                                if (data == 'error') return;
                            //                                modelCompany.clear()
                            //                                modelForCombo.clear()

                            //                                for (var i in data) {

                            //                                    modelCompany.append({
                            //                                                            uid: data[i].nid[0].value,
                            //                                                            name: data[i].title[0].value,
                            //                                                            address: data[i].field_address_org[0].value
                            //                                                        })

                            //                                    modelForCombo.append({text: data[i].title[0].value})


                            //                                }

                            //                                MAIN.getData('/banks', function(banks){
                            //                                    modelBank.clear()

                            //                                    for (var i in data) {
                            //                                        modelBank.append({
                            //                                                             uid: data[i].nid[0].value,
                            //                                                             name: data[i].title[0].value,
                            //                                                             url: data[i].field_bank_url[0].uri
                            //                                                         })
                            //                                    }
                            //                                })

                            //                            })


                        }
                    }




                    Button {
                        id: btnRegister
                        highlighted: true
                        width: parent.width - 70
                        text: 'Register'
                        anchors.horizontalCenter: parent.horizontalCenter

                        ToolTip.timeout: 5000

                        onClicked: {


                            if (txtPassword.text !== txtConfirmPassword.text) {
                                this.ToolTip.text = 'Passwords are not matching'
                                this.ToolTip.visible = true
                                return
                            }
                            if(txtUserName.text == '' ) {
                                this.ToolTip.text = 'Please fill in all the fields'
                                this.ToolTip.visible = true
                                return
                            }
                            if(txtPassword.text.length < 4) {
                                this.ToolTip.text = 'Password should be atleast 4 Characters'
                                this.ToolTip.visible = true
                                return
                            }

                            if(_SELECTED_BANKS.length == 0) {
                                this.ToolTip.text = 'Please select at least one Bank'
                                this.ToolTip.visible = true
                                return
                            }

                            _SELECTED_BANKS = removeDuplicates(_SELECTED_BANKS);


                            busyIndicatorRegisterPage.visible = true

                            isUserUnique(txtUserName.text, function(result) {
                                if(result){
                                    registerUserDrupal(function(data) {
                                        busyIndicatorRegisterPage.visible = false

                                        if(data === 'error') {
                                            btnRegister.ToolTip.text = 'Check Internet Connection'
                                            btnRegister.ToolTip.visible = true
                                            return
                                        }

                                        // clear all text
                                        txtConfirmPassword.text = ''
                                        txtPassword.text = ''
                                        txtUserName.text = ''

                                        //

                                        paneRegister.visible = false
                                        paneLogin.visible = true

                                    })
                                }
                                else {
                                    busyIndicatorRegisterPage.visible = false
                                    btnRegister.ToolTip.text = 'Username already registered'
                                    btnRegister.ToolTip.visible = true
                                    return
                                }
                            })


                        }
                    }


                }
            }
        }

        footer: TabBar {
            TabButton {
                id: tabButtonLogin
                text: 'Login'
                onClicked: {
                    paneRegister.visible = false
                    paneLogin.visible = true
                }
            }

            TabButton {
                text: 'Register'
                onClicked: {
                    paneRegister.visible = true
                    paneLogin.visible = false

                }
            }
        }

    }

    ListModel {
        id: modelForCombo
    }

    FontLoader {
        id: fontAwesome
        source: 'qrc:/fontawesome-webfont.ttf'
    }
    FontLoader {
        id: fontLato
        source: './Lato-Light.ttf'
    }

    function getCompanies() {

        var data = []

        var url = _URL + '/company'
        var xhr = new XMLHttpRequest()

        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {

            if (xhr.readyState === XMLHttpRequest.DONE) {

                if( xhr.responseText == '') { _CON = false; return console.log('No Internet Connection')  }



                data = JSON.parse(xhr.responseText)

                modelCompany.clear()
                modelForCombo.clear()

                for (var i in data) {

                    modelCompany.append({
                                            uid: data[i].nid[0].value,
                                            name: data[i].title[0].value,
                                            address: data[i].field_address_org[0].value
                                        })

                    modelForCombo.append({text: data[i].title[0].value})


                }

            }
        }
        xhr.send();
    }

    function getBanks() {

        var data = []

        var url = _URL + '/banks'
        var xhr = new XMLHttpRequest()

        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {

            if (xhr.readyState === XMLHttpRequest.DONE) {

                if( xhr.responseText == '') { _CON = false;  return console.log('No Internet Connection');  }



                modelBank.clear()

                data = JSON.parse(xhr.responseText)

                for (var i in data) {
                    modelBank.append({
                                         uid: data[i].nid[0].value,
                                         name: data[i].title[0].value,
                                         url: data[i].field_bank_url[0].uri
                                     })
                }

            }
        }
        xhr.send();
    }


    function registerUser(callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("POST", _URL_PARSE + "/parse/classes/users", true);
        xhr.setRequestHeader("X-Parse-Application-Id", _PARSE_APPLICATION_ID);
        xhr.setRequestHeader("X-Parse-REST-API-Key", _PARSE_MASTER_KEY);
        xhr.setRequestHeader("Content-Type", "application/json");

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                var result = JSON.parse(xhr.responseText);
                if (result.objectId) {
                    console.log("saved an object with id: " + result.objectId);
                    callback()
                }
            }
        }

        var data = JSON.stringify({
                                      userName: txtUserName.text,
                                      password: txtPassword.text,
                                      mobileNumber: txtMobileNumber.text
                                  });
        xhr.send(data);
    }

    function registerUserDrupal(callback) {
        var xhr = new XMLHttpRequest();
        xhr.withCredentials = true;

        var banksSelected = []

        _SELECTED_BANKS.forEach(function(bank) {
            banksSelected.push({"value": bank})
        })

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if( xhr.responseText == '') {  callback('error'); return }
                var result = JSON.parse(xhr.responseText);
                callback(result)

            }
        }

        xhr.open("POST", _URL + "/entity/node");
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("content-type", "application/hal+json");
        xhr.setRequestHeader("authorization", "Basic YWRtaW46YXNkZmdo");
        xhr.setRequestHeader("cache-control", "no-cache");
        xhr.setRequestHeader("postman-token", "39e7b16a-af1f-f279-dcb2-2c3080c04a45");



        var data = JSON.stringify({
                                      _links: {type: {href: _URL + '/rest/type/node/user'}},
                                      title: [{value: txtUserName.text}],
                                      field_username: [{value: txtUserName.text}],
                                      field_company: [{value: comboCompany.currentText ? getCompanyId(comboCompany.currentText): ''}],
                                      field_password: [{value: txtPassword.text}],
                                      field_banks: banksSelected
                                  });


        xhr.send(data);


    }

    function updateUserDrupal(nodeId, userName, password,  callback) {
        var xhr = new XMLHttpRequest();
        xhr.withCredentials = true;

        var banksSelected = []

        _SELECTED_BANKS.forEach(function(bank) {
            banksSelected.push({"value": bank})
        })

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if( xhr.responseText == '') {  callback('error'); return }
                var result = JSON.parse(xhr.responseText);
                callback(result)

            }
        }

        xhr.open("PATCH", _URL + "/node/" + nodeId);
        xhr.setRequestHeader("accept", "application/json");
        xhr.setRequestHeader("content-type", "application/hal+json");
        xhr.setRequestHeader("authorization", "Basic YWRtaW46YXNkZmdo");
        xhr.setRequestHeader("cache-control", "no-cache");
        xhr.setRequestHeader("postman-token", "39e7b16a-af1f-f279-dcb2-2c3080c04a45");

        console.log('NODEID ' + nodeId )



        var data = ''

        if (password === ''){
            data = JSON.stringify({
                                      _links: {type: {href: _URL + '/rest/type/node/user'}},
                                      nid: {
                                          "": {
                                              value: nodeId
                                          }
                                      },
                                      field_company: [{value: _USER_COMPANY ? _USER_COMPANY : ''}],
                                      field_banks: banksSelected
                                  });
        }
        else {
            data = JSON.stringify({
                                      _links: {type: {href: _URL + '/rest/type/node/user'}},
                                      nid: {
                                          "": {
                                              value: nodeId
                                          }
                                      },
                                      field_company: [{value: _USER_COMPANY ? _USER_COMPANY : ''}],
                                      field_banks: banksSelected,
                                      field_password: [{'value':  password}]
                                  });

        }



        console.log(data)
        xhr.send(data);


    }


    function loginUser(callback) {
        var xhr = new XMLHttpRequest();
        xhr.open("GET", _URL_PARSE + "/parse/classes/login", true);
        xhr.setRequestHeader("X-Parse-Application-Id", _PARSE_APPLICATION_ID);
        xhr.setRequestHeader("X-Parse-REST-API-Key", _PARSE_MASTER_KEY);

        xhr.onreadystatechange = function() {
            if (xhr.readyState == 4) {
                if( xhr.responseText == '') {  console.log('No Internet Connection'); return }
                var result = JSON.parse(xhr.responseText);
                if (result.objectId) {
                    console.log(" Login User ID:" + result.objectId);
                    callback()
                }
            }
        }

        var data = 'userName=' + encodeURIComponent(txtLoginUserName.text) + '&password=' + encodeURIComponent(txtLoginPassword.text);
        // var data = 'userName=' + txtLoginUserName.text + '&password=' + txtLoginPassword.text;
        xhr.send(data);
    }


    function loginUserDrupal(callback) {
        var data = []

        var url = _URL + '/user-list/' + txtLoginUserName.text
        var xhr = new XMLHttpRequest()

        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {

            if (xhr.readyState === XMLHttpRequest.DONE) {

                if( xhr.responseText == '') {  return callback('error') }

                data = JSON.parse(xhr.responseText)
                return callback(data);


            }
        }
        xhr.send();
    }

    function isUserUnique(username, callback) {
        var data = []

        var url = _URL + '/user-list/' + username
        var xhr = new XMLHttpRequest()

        xhr.open('GET', url, true);
        xhr.onreadystatechange = function() {

            if (xhr.readyState === XMLHttpRequest.DONE) {

                if( xhr.responseText == '') {  return callback(false)}

                data = JSON.parse(xhr.responseText)
                if(data.length === 0) return callback(true)
                else return callback(false)


            }
        }
        xhr.send();
    }


    function getBankObj(id) {
        var obj = {}
        for (var i = 0 ; i < modelBank.count; i++) {
            if (modelBank.get(i).uid === id) obj = modelBank.get(i)
        }

        return obj
    }

    function getBankId(text) {
        var id;
        for (var i = 0 ; i < modelBank.count; i++) {
            if (modelBank.get(i).name === text) id = modelBank.get(i)
        }

        return id.uid
    }

    function getCompanyObj(id) {
        var obj = {}
        for (var i = 0 ; i < modelCompany.count; i++) {
            if (modelCompany.get(i).uid === id) obj = modelCompany.get(i)
        }

        return obj
    }

    function getCompanyId(text) {
        var id;
        for (var i = 0 ; i < modelCompany.count; i++) {
            if (modelCompany.get(i).name === text) id = modelCompany.get(i)
        }

        return id.uid
    }

    function savePictures(filename, mp3Url, callback){
        if(Qt.platform.os == 'linux'){
            if (Requisites.isFileExists('file://'+ Requisites.currentLocation() + '/Images/' + filename)) return 'file://'+ Requisites.currentLocation() + '/Images/' + filename

        }
        if(Qt.platform.os == 'android'){
            if (androidPermissions.getIsMarshmallowOrAbove) {
                console.log("Marshmallow")

                androidPermissions.requestPermissions();

            }

            if (Requisites.isFileExists('file://' +mobileDevice.primaryStoragePath() + "/Discounts/Images/" + filename)) return 'file://' + mobileDevice.primaryStoragePath() + "/Discounts/Images/" + filename

        }

        if (Qt.platform.os == 'ios') {
            if (Requisites.isFileExists('file://' +Requisites.standardPath() + "/Discounts/Images/" + filename)) return 'file://' + Requisites.standardPath() + "/Discounts/Images/" + filename

        }



        var url = mp3Url;
        var xhr = new XMLHttpRequest()

        xhr.open('GET', url, true);
        xhr.responseType = 'arraybuffer';
        xhr.onreadystatechange = function() {

            if(xhr.status === 0 || xhr.status === 404 )
                return

            if (xhr.readyState === XMLHttpRequest.DONE) {

                if (xhr.response) {
                    var mp3Base64  = arrayBufferDataUri(xhr.response)

                    console.log("Image Received from " + url + '...')


                    // Desktop
                    if(Qt.platform.os == 'linux'){
                        Requisites.saveBase64StringToBinaryFile(mp3Base64, "Images/" + filename )
                        callback('file:'+ Requisites.currentLocation() + '/Images/' + filename)
                    }

                    // Android

                    if(Qt.platform.os == 'android') {
                         Requisites.saveBase64StringToBinaryFile(mp3Base64, mobileDevice.primaryStoragePath() + "/Discounts/Images/" + filename  )
                        callback('file://' + mobileDevice.primaryStoragePath() + "/Discounts/Images/" + filename)
                    }

                    //iOs
                    if(Qt.platform.os == 'ios') {
                        var result = Requisites.saveBase64StringToBinaryFile(mp3Base64, Requisites.standardPath() + "/Discounts/Images/" + filename  )
                        console.log('Save Result: ' + result )
                        callback('file://' + Requisites.standardPath() + "/Discounts/Images/" + filename)
                    }


                }
            }
        };

        console.log("Downloading Image from " + url + '...')
        xhr.send();

    }

    function arrayBufferDataUri(raw) {
        var base64 = ''
        var encodings = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

        var bytes = new Uint8Array(raw)
        var byteLength = bytes.byteLength
        var byteRemainder = byteLength % 3
        var mainLength = byteLength - byteRemainder

        var a, b, c, d
        var chunk

        // Main loop deals with bytes in chunks of 3
        for (var i = 0; i < mainLength; i = i + 3) {
            // Combine the three bytes into a single integer
            chunk = (bytes[i] << 16) | (bytes[i + 1] << 8) | bytes[i + 2]

            // Use bitmasks to extract 6-bit segments from the triplet
            a = (chunk & 16515072) >> 18 // 16515072 = (2^6 - 1) << 18
            b = (chunk & 258048) >> 12 // 258048   = (2^6 - 1) << 12
            c = (chunk & 4032) >> 6 // 4032     = (2^6 - 1) << 6
            d = chunk & 63 // 63       = 2^6 - 1
            // Convert the raw binary segments to the appropriate ASCII encoding
            base64 += encodings[a] + encodings[b] + encodings[c] + encodings[d]
        }

        // Deal with the remaining bytes and padding
        if (byteRemainder == 1) {
            chunk = bytes[mainLength]

            a = (chunk & 252) >> 2 // 252 = (2^6 - 1) << 2
            // Set the 4 least significant bits to zero
            b = (chunk & 3) << 4 // 3   = 2^2 - 1
            base64 += encodings[a] + encodings[b] + '=='
        } else if (byteRemainder == 2) {
            chunk = (bytes[mainLength] << 8) | bytes[mainLength + 1]

            a = (chunk & 16128) >> 8 // 16128 = (2^6 - 1) << 8
            b = (chunk & 1008) >> 4 // 1008  = (2^6 - 1) << 4
            // Set the 2 least significant bits to zero
            c = (chunk & 15) << 2 // 15    = 2^4 - 1
            base64 += encodings[a] + encodings[b] + encodings[c] + '='
        }

        return base64
    }


    function userLogAdd(userDetails, actionType) {


        _DB.transaction(
                    function(tx) {
                        // Create the tables if it doesn't already exist
                        tx.executeSql('CREATE TABLE IF NOT EXISTS UserDev(userName TEXT, company TEXT, type TEXT)');
                        tx.executeSql('CREATE TABLE IF NOT EXISTS UserBanks(bankName TEXT)');

                        tx.executeSql('DELETE FROM UserDev')
                        tx.executeSql('DELETE FROM UserBanks')

                        if (actionType === 'Logout') {
                            return;
                        }

                        var user = {
                            userId: userDetails.userId,
                            userName: userDetails.userName
                        }

                        tx.executeSql('INSERT INTO UserDev VALUES(?, ?, ?)', [ JSON.stringify(user), userDetails.company, 'Login' ]);
                        userDetails.banks.forEach(function(bank) {
                            tx.executeSql('INSERT INTO UserBanks VALUES(?)', [ bank]);
                        })
                    })
    }

    function isUserLoggedIn() {


        var status = ''




        _DB.transaction(function(tx) {

            tx.executeSql('CREATE TABLE IF NOT EXISTS UserDev(userName TEXT, company TEXT, type TEXT)');
            tx.executeSql('CREATE TABLE IF NOT EXISTS UserBanks(bankName TEXT)');


            var  rs = tx.executeSql('SELECT * FROM UserDev');
            status = rs.rows.item(0)? rs.rows.item(0).userName : ''
            _USER_COMPANY = rs.rows.item(0) ? rs.rows.item(0).company : ''

        })



        if (status == '') return ''

        try {
            var user = JSON.parse(status)
            _USER_NAME = user.userName
            _USER_ID = user.userId
        }
        catch (err) {
            _USER_NAME = status
        }







        _DB.transaction(function(tx) {
            var  rs = tx.executeSql('SELECT * FROM UserBanks');

            _USER_BANKS = []
            for (var i =0; i < rs.rows.length; i++ ) {
                _USER_BANKS.push(rs.rows.item(i).bankName)
            }

        })

        return status
    }


    function loginPageEssentials() {
        MAIN.getData('/company/en', function(data) {
            if (data == 'error') return;
            modelCompany.clear()
            modelForCombo.clear()

            for (var i in data) {

                modelCompany.append({
                                        uid: data[i].nid[0].value,
                                        name: data[i].title[0].value,
                                        address: data[i].field_address_org[0]? data[i].field_address_org[0].value : ''
                                    })

                modelForCombo.append({text: data[i].title[0].value})


            }

            MAIN.getData('/banks/en', function(banks){
                modelBank.clear()

                for (var i in banks) {
                    modelBank.append({
                                         uid: banks[i].nid[0].value,
                                         name: banks[i].title[0].value,
                                         url: banks[i].field_bank_url[0]? banks[i].field_bank_url[0].uri : ''
                                     })
                }
            })

        })
    }

    function removeA(arr) {
        var what, a = arguments, L = a.length, ax;
        while (L > 1 && arr.length) {
            what = a[--L];
            while ((ax= arr.indexOf(what)) !== -1) {
                arr.splice(ax, 1);
            }
        }
        return arr;
    }

    function removeDuplicates(arr) {
        var a = [];
        var l = arr.length;
        for(var i=0; i<l; i++) {
            for(var j=i+1; j<l; j++) {
                // If arr[i] is found later in the array
                if (arr[i] === arr[j])
                    j = ++i;
            }
            a.push(arr[i]);
        }
        return a;
    }

    onClosing: {
        if (Qt.platform.os == "android") {
            close.accepted = false;
            homePage.goBack();
        }
    }


}
