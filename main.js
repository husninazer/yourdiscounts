.import "home.js" as HOME

function startFetch(lang) {



    getData('/banks/' + lang, function(banks) {
        if (banks === 'error' || !_CON) HOME.populateBanks(HOME.getDataFromDB('Banks'));
        else HOME.populateBanks(banks);

        getData('/company/' + lang, function(companies) {
            if (companies === 'error') HOME.populateCompanies(HOME.getDataFromDB('Companies'));
            else HOME.populateCompanies(companies)


            getData('/category/' + lang,function(categoryResult) {
                if (categoryResult === 'error') HOME.populateCategory(HOME.getDataFromDB('Categories'));
                else HOME.populateCategory(categoryResult)

                getData('/organizations/' + lang, function(orgResult) {
                    if (orgResult=== 'error') HOME.populateOrganization(HOME.getDataFromDB('Organizations'));
                    else HOME.populateOrganization(orgResult)


                    getData('/org-collection-list/' + lang, function(offerOrgListResult) {
                        if (offerOrgListResult === 'error') HOME.populateOfferCollection(HOME.getDataFromDB('CollectionLists'));
                         else HOME.populateOfferCollection(offerOrgListResult)


                        getData('/offers/' + lang, function(offerResult) {
                            if (offerResult === 'error') HOME.populateOffer(HOME.getDataFromDB('Offers'));
                            else HOME.populateOffer(offerResult)
                        })
                    })
                })
            })
        })
    })

}

function getData(restUrl, callback) {

    if (!_CON) return callback('error')

    var data = []
    var url = _URL + restUrl
    var xhr = !xhr? new XMLHttpRequest(): xhr

    xhr.open('GET', url, true);
    xhr.onreadystatechange = function() {

        if (xhr.readyState === XMLHttpRequest.DONE) {


            if( xhr.responseText == '') {_CON = false;  return callback('error') }
           // _CON = true;

            data = JSON.parse(xhr.responseText)

            console.log("Response from " + url + ' Received. Total Object(s): ' + data.length)
            callback(data)
        }
    }
    console.log("Connecting to " + url + '...')
    xhr.send();
}

function handleBackButton() {
    if(stackViewSecondary.depth > 1) {
        stackViewSecondary.pop(); return
    }
    stackViewSecondary.clear()
    stackViewSecondary.visible = false

}
