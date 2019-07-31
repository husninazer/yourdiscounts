import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3

import QtPositioning 5.2
import QtLocation 5.3

import QtWebView 1.0

import "main.js" as MAIN

import QtQuick.Controls.Material 2.0

import Qt.labs.settings 1.0


Page {
    id: root

    enabled: !busyIndicatorProfilePage.visible



    BusyIndicator {
        id: busyIndicatorProfilePage
        visible: modelOffer.count < 1? true: false
        anchors.top: parent.top; anchors.topMargin: 50
        anchors.horizontalCenter: parent.horizontalCenter
        z: 150
    }

    Component.onCompleted: {
        _SELECTED_BANKS =[]
        _SELECTED_BANKS = _USER_BANKS

        txtProfilePassword.visible = false
        txtProfilePasswordConfirm.visible = false
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
                text: settings._LANGUAGE == 'en'? 'Your Profile' : 'ملفك الشخصي'
                anchors.horizontalCenter: parent.horizontalCenter
                font.pixelSize: 20
            }



            Label {
                text: settings._LANGUAGE == 'en'? 'Your Bank Accounts' : 'البنك الخاص بك'
                topPadding: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ComboBox {
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 80

                model: modelBank


                delegate: CheckBox {

                    text: name
                    width: root.width - 70

                    checked: isSelected(uid)

                    onCheckStateChanged: {

                        var id = getBankId(text);
                        if (checkState == Qt.Checked) {
                            _SELECTED_BANKS.push(id)

                            console.log('SELECTED BANKS: ' +  JSON.stringify(_SELECTED_BANKS))
                        }

                        else {
                            _SELECTED_BANKS.forEach(function(arrayText){
                                if (id === arrayText) removeA(_SELECTED_BANKS, id)
                                console.log('SELECTED BANKS: ' + JSON.stringify(_SELECTED_BANKS))
                            })
                        }
                    }
                }

            }


            Label {
                text: settings._LANGUAGE == 'en'? 'Your Company' : 'شركتك'
                topPadding: 20
                anchors.horizontalCenter: parent.horizontalCenter
            }

            ComboBox {
                id: comboCompany
                model: modelForCombo


                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 80
                Component.onCompleted:  {


                }
            }


            Label {
                text: settings._LANGUAGE == 'en'? 'Change Password' : 'تغيير كلمة السر'
                topPadding: 20
                anchors.horizontalCenter: parent.horizontalCenter

                MouseArea {
                    anchors.fill: parent

                    onClicked: {
                        txtProfilePassword.visible = !txtProfilePassword.visible
                        txtProfilePasswordConfirm.visible = !txtProfilePasswordConfirm.visible
                    }
                }
            }

            TextField {
                id: txtProfilePassword
                placeholderText: settings._LANGUAGE == 'en'? 'New Password': 'كلمة السر الجديدة'
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 80

                Component.onCompleted: {
                    visible: false
                }
            }

            TextField {
                id: txtProfilePasswordConfirm
                placeholderText: settings._LANGUAGE == 'en'? 'Confirm New Password' : 'تأكيد كلمة المرور الجديدة'
                echoMode: TextInput.Password
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width - 80

                Component.onCompleted: {
                    visible: false
                }
            }




            Button {
                id: btnRegister
                highlighted: true
                width: parent.width - 70
                text: settings._LANGUAGE == 'en'? 'Update Profile' : 'تحديث الملف'
                anchors.horizontalCenter: parent.horizontalCenter

                ToolTip.timeout: 5000

                onClicked: {

                    // STEPS: 1. Userlogout 2. Userlogin 3. start fetch.



                    if(_SELECTED_BANKS.length == 0) {
                        this.ToolTip.text = settings._LANGUAGE == 'en'? 'Please select at least one Bank' : 'يرجى اختيار بنك واحد على الأقل'
                        this.ToolTip.visible = true
                        return
                    }

                    if(txtProfilePassword.text != txtProfilePasswordConfirm.text) {
                        this.ToolTip.text = settings._LANGUAGE == 'en'? 'Passwords do not match' : 'كلمات المرور غير متطابقة'
                        this.ToolTip.visible = true
                        return
                    }

                    _SELECTED_BANKS = removeDuplicates(_SELECTED_BANKS);

                    console.log(_SELECTED_BANKS)

                    //  busyIndicatorRegisterPage.visible = true


                    var userDetails = {
                        userId: _USER_ID,
                        userName: _USER_NAME,
                        company: _USER_COMPANY,
                        banks: _SELECTED_BANKS
                    }

                    var password = txtProfilePassword.text

                    updateUserDrupal(_USER_ID, _USER_NAME, password,   function (response){
                        console.log(JSON.stringify(response))
                        userLogAdd('user', 'Logout')
                        userLogAdd(userDetails, 'Login')

                        _SELECTED_BANKS = []


                        filteredOffereeModel.clear()
                        filteredOffereeModelForCompany.clear()
                        filteredOffererModel.clear()
                        filteredOrgModel.clear()

                        modelCategory.clear()
                        modelOffer.clear()
                        modelOfferCollection.clear()
                        modelOfferDuplicates.clear()
                        modelOrganization.clear()


                        MAIN.startFetch(settings._LANGUAGE)


                    })
                }
            }
        }
    }

    function isSelected(uid) {
        var status = false
        _USER_BANKS.forEach(function(bankID) {
            if (bankID === uid) status = true
        })

        return status
    }
}
