'use strict'

angular.module('app.company.ctrls', [])

.controller('NewCompanyCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http ) ->
        console.log "@NewCompanyCtrl 4: Mayor->GerenteComercial :)"
        # ng-model 4 company
        $scope.company = 
            businessOwner: ''
            businessName: ''
            nit: ''
            email: ''
            emailAdministrative: ''
            emailAccounting: ''
            emailSales: ''
            address: ''
            phone: ''
            citySelected: ''

        # Load cities
        getCities = ->
            $filters=
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/City/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.cities = postResponse
        getCities()

        $scope.showInfoOnSubmit = false

        original = angular.copy($scope.company)

        $scope.revert = ->
            $scope.company = angular.copy(original)
            $scope.form_NewCompany.$setPristine()

        $scope.canRevert = ->
            return !angular.equals($scope.company, original) || !$scope.form_NewCompany.$pristine

        $scope.canSubmit = ->
            return $scope.form_NewCompany.$valid && !angular.equals($scope.company, original)

        $scope.submitForm = ->
             $scope.showInfoOnSubmit = true
             $scope.revert()     

        # Create New Company
        $scope.createNewCompany = ->
            # Data Object
            $scope.data = 
                businessOwner: $scope.company.businessOwner
                businessName: $scope.company.businessName
                nit: $scope.company.nit
                email: $scope.company.email
                emailAdministrative: $scope.company.emailAdministrative
                emailAccounting: $scope.company.emailAccounting
                emailSales: $scope.company.emailSales
                address: $scope.company.address
                phone: $scope.company.phone
                geoID: $scope.company.citySelected.geoID
                
            $http.defaults.headers.post["Content-Type"] = "application/json"            
                        
            $http({ url: REST_API.hostname+"/server/ajax/Company/addCompany.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse.indexOf("NIT") > -1)
                        # console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "La empresa con el NIT" + $scope.data.nit + "ya está en la base de datos."
                    if (postResponse.indexOf("email") > -1)
                        # console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "La empresa con ese EMAIL" + $scope.data.email + " ya está en la base de datos."
                else
                    # console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logSuccess "Se ha creado exitosamente la empresa: "+$scope.data.businessName
                    # logger.logWarning "Espere unos momentos se esta enviando el correo..."
                    $scope.revert()

                    #Sending Email
                    $http({ url: REST_API.hostname+"/server/ajax/Company/addCompanyConfirm.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
                    .success (postResponseB) ->
                        # console.log "Roy: " + JSON.stringify(postResponseB)
                        logger.logSuccess "Se ha enviado el correo exitosamente a: "+ $scope.data.email
                    .error (postResponseB) ->
                        # console.log "error enviando el correo"
                        logger.logError "Ha ocurrido un error enviando el correo. Por favor contacte al Administrador"

            .error (postResponse) ->
                console.log "error"
            return
        return
        
])


.controller('listCompaniesCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'listCompaniesCtrl'

        $scope.retailers = []
        $scope.searchKeywords = ''
        $scope.filteredRetailers = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRetailers = $scope.filteredRetailers.slice(start, end)

        # on page change: change numPerPage, filtering string
        $scope.onFilterChange = ->
            $scope.select(1)
            $scope.currentPage = 1
            $scope.row = ''

        $scope.onNumPerPageChange = ->
            $scope.select(1)
            $scope.currentPage = 1

        $scope.onOrderChange = ->
            $scope.select(1)
            $scope.currentPage = 1            


        $scope.search = ->
            $scope.filteredRetailers = $filter('filter')($scope.retailers, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRetailers = $filter('orderBy')($scope.retailers, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageRetailers = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        #Load companies
        getRetailerCompanies = ->
            $filters=
                isRetailer: true
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Company/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    # console.log postResponse
                    $scope.retailers =postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDretailerUP').trigger('click')
                    if $scope.filteredRetailers.length==0
                        logger.logError "No se encontraron empresas registradas en su pais."
                    else
                        logger.logSuccess "Tiene "+$scope.filteredRetailers.length+" empresas registradas."
                , 100
            return
        getRetailerCompanies()

        # # Getting retailers4country
        # retailers4country = ->
        #     $filters=
        #         userID: $scope.currentUser.userID
        #     $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/listByuserID.php", method: "POST", data: JSON.stringify($filters) })
        #     .success (postResponse) ->
        #         $scope.retailers=postResponse
        #         for i in [0...$scope.retailers.length] by 1
        #             $scope.retailers[i]['creationDate']=moment($scope.retailers[i]['creationDate']).format("DD/MM/YYYY")
            
        #         # Only way to make react on filter to show items on table
        #         setTimeout ->
        #             $('#searchKeywords').focus()
        #             angular.element('#orderIDretailerUP').trigger('click')
        #             if $scope.filteredRetailers.length==0
        #                 logger.logError "No se encontraron cupones registrados en su cuenta."
        #             else
        #                 logger.logSuccess "Tiene "+$scope.filteredRetailers.length+" cupones de Rifa."
        #         , 100
                
        # retailers4country()

])
