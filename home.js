

function populateBanks(data) {
    modelBank.clear()

    if (data == '') return

    for (var i in data) {
        modelBank.append({
                             uid: data[i].nid[0].value,
                             name: data[i].title[0].value,
                             url: data[i].field_bank_url[0] ? data[i].field_bank_url[0].uri : '',
                                                              picture: data[i].field_bank_logo[0]? data[i].field_bank_logo[0].url : ''

                         })
    }

    addDatatoDB('Banks', data)

}



function populateCompanies(data) {
    modelCompany.clear()
    modelForCombo.clear()

    for (var i in data) {
        modelCompany.append({
                                uid: data[i].nid[0].value,
                                name: data[i].title[0].value,
                                address: data[i].field_address_org[0] ? data[i].field_address_org[0].value : ''
                            })

        modelForCombo.append({text: data[i].title[0].value})

    }


    addDatatoDB('Companies', data)
}

function  populateCategory(categoryResult) {
    //    _JSON_CAT =  categoryResult
    modelCategory.clear()
    modelCategory.append({name: 'All'})
    for (var i in categoryResult) {
        var obj = {}
        obj = {
            "uid": categoryResult[i].nid[0].value,
            "name": categoryResult[i].title[0].value
        }

        modelCategory.append(obj)
    }

    addDatatoDB('Categories', categoryResult)


}

function populateOrganization(result) {
    //    _JSON_ORG = result
    modelOrganization.clear()
    var insertObject = {}
    for (var i in result) {
        var category = ''
        insertObject = {}
        for (var j=0; j < modelCategory.count; j++) {
            if (modelCategory.get(j).uid === result[i].field_category[0].target_id) {
                category = modelCategory.get(j).name;

                insertObject = {
                    "uid": result[i].nid[0].value,
                    "category": category,
                    "name": result[i].title[0].value,
                    "address": result[i].field_address_org[0] ? result[i].field_address_org[0].value: '',
                                                                "picture": result[i].field_picture_org[0] ? result[i].field_picture_org[0].url : '',
                                                                                                            "locationLat": result[i].field_location_org[0] ? result[i].field_location_org[0].lat : '',
                                                                                                                                                             "locationLong": result[i].field_location_org[0] ? result[i].field_location_org[0].lng : ''
                }


                modelOrganization.append(insertObject)
            }
        }


    }

    addDatatoDB('Organizations', result);


}

function populateOfferCollection(offerOrgListResult) {
    modelOfferCollection.clear()
    for (var i in offerOrgListResult) {
        var organization = {}
        var fCollection = {}
        for (var j=0; j< modelOrganization.count; j++) {
            if (modelOrganization.get(j).uid === offerOrgListResult[i].field_organization[0].target_id) {
                organization = modelOrganization.get(j)
                fCollection = offerOrgListResult[i]

                var obj = {
                    uid: organization.uid,
                    fid:  fCollection.item_id[0].value ,
                    category: organization.category,
                    name: organization.name,
                    address: organization.address,
                    picture: organization.picture,
                    locationLat: organization.locationLat,
                    locationLong: organization.locationLong,
                    offerPercent:  fCollection.field_offer_percent[0]? fCollection.field_offer_percent[0].value : '',
                                                                       offerAmount: fCollection.field_offeramount[0]? fCollection.field_offeramount[0].value : ''
                }

                modelOfferCollection.append(obj)
            }
        }

    }

    addDatatoDB('CollectionLists', offerOrgListResult)
}

function populateOffer(offerResult) {
    modelOffer.clear()
    modelOfferDuplicates.clear()
    var saved = []

    for (var i in offerResult) {
        var offer = {}
        var fCollection = {}

        for (var j in offerResult[i].field_offer) {
            var save_flag = true
            var save_bank_flag = false

            for (var k=0; k < modelOfferCollection.count; k++)
                if (modelOfferCollection.get(k).fid === offerResult[i].field_offer[j].value) {
                    fCollection = modelOfferCollection.get(k);
                    offer = offerResult[i]

                    for (var l in saved) {
                        if (fCollection.uid === saved[l])
                            save_flag = false
                    }

                    // filter the company working
                    if ( offer.type[0].target_id === 'company_offers') {
                        if (_USER_COMPANY === '') continue
                        if (_USER_COMPANY !== offer.field_organization[0].target_id) continue
                    }


                    // filter the bank working
                    if ( offer.type[0].target_id === 'offer') {
                        if (_USER_BANKS.length == 0) continue
                        for (var b = 0; b < _USER_BANKS.length; b++) {
                            if (_USER_BANKS[b] === offer.field_bank_offering[0].target_id) {
                                save_bank_flag = true;
                            }
                        }
                    }

                    if (!save_bank_flag) continue


                    if(save_flag){
                        var obj = {
                            uid: fCollection.uid,
                            fid: fCollection.fid,
                            category: fCollection.category,
                            name: fCollection.name,
                            address: fCollection.address,
                            picture: fCollection.picture,
                            locationLat: fCollection.locationLat,
                            locationLong: fCollection.locationLong,
                            offerPercent: fCollection.offerPercent,
                            offerAmount: fCollection.offerAmount,
                            expiryDate: offer.field_expiry_date[0].value,
                            offerLink: offer.type[0].target_id === 'offer'? offer.field_offer_link[0]? offer.field_offer_link[0].uri : '' : '',
                                                                                                       bankOffering: offer.type[0].target_id === 'offer'? offer.field_bank_offering[0].target_id : '',
                                                                                                                                                          companyOffering: offer.type[0].target_id === 'company_offers'? offer.field_organization[0].target_id : '',
                                                                                                                                                                                                                         ourOffering: offer.type[0].target_id === 'our_offers'? "true" : "false"

                        }

                        saved.push(fCollection.uid)
                        modelOffer.append(obj)
                    }


                    var obj1 = {
                        uid: fCollection.uid,
                        fid: fCollection.fid,
                        category: fCollection.category,
                        name: fCollection.name,
                        address: fCollection.address,
                        picture: fCollection.picture,
                        locationLat: fCollection.locationLat,
                        locationLong: fCollection.locationLong,
                        offerPercent: fCollection.offerPercent,
                        offerAmount: fCollection.offerAmount,
                        expiryDate: offer.field_expiry_date[0].value,
                        offerLink: offer.type[0].target_id === 'offer'? offer.field_offer_link[0]? offer.field_offer_link[0].uri : '': '',
                                                                                                   bankOffering: offer.type[0].target_id === 'offer'? offer.field_bank_offering[0].target_id : '',
                                                                                                                                                      companyOffering: offer.type[0].target_id === 'company_offers'? offer.field_organization[0].target_id : '',
                                                                                                                                                                                                                     ourOffering: offer.type[0].target_id === 'our_offers'? "true" : "false"
                    }

                    modelOfferDuplicates.append(obj1)


                }
        }

    }

    addDatatoDB('Offers', offerResult)

}

function getDataFromDB(table) {

    var data;

    console.log('Retreiving from Table ' + table)

    _DB.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS ' + table +'(data TEXT)');
        data = tx.executeSql('SELECT * FROM ' + table);

    })

    return data.rows.item(0)? JSON.parse(data.rows.item(0).data) : ''

}

function addDatatoDB(table, data) {

    console.log('Inserting into Database for ' + table);
    _DB.transaction(function(tx) {

        tx.executeSql('CREATE TABLE IF NOT EXISTS ' + table + '(data TEXT)');
        tx.executeSql('DELETE FROM ' + table);
        tx.executeSql('INSERT  INTO ' + table + ' VALUES(?)', JSON.stringify(data));
    })
}


