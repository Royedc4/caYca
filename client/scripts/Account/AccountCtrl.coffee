'use strict'

angular.module('app.account.ctrls', [])

.controller('LoginCtrl', [
    'REST_API','AUTH_EVENTS','$scope', '$http', 'LoginService', 'logger', '$rootScope', '$location'
    (REST_API,AUTH_EVENTS, $scope, $http, LoginService, logger, $rootScope, $location) ->
        console.log "@LoginCtrl :)"
        $scope.credentials = 
            email:   ""
            password:   ""

        original = angular.copy($scope.credentials)

        $scope.canSubmit = ->
            return $scope.form_Login.$valid && !angular.equals($scope.credentials, original)

        # get Country4User
        getCountry4user = (user) ->
            $filters=
                country: user['country']
            $http({ url: REST_API.hostname+"/server/ajax/Country/get.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.currentUser['country']=postResponse['0']

        # get company4User
        getCompany4user = (user) ->
            $filters=
                companyID: user['companyID']
            $http({ url: REST_API.hostname+"/server/ajax/Company/get.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.currentUser['company']=postResponse['0']

        # get city4User
        getCity4user = (user) ->
            $filters=
                geoID: user['city_geoID']
            $http({ url: REST_API.hostname+"/server/ajax/City/get.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.currentUser['city']=postResponse['0']

        # get userType4User
        getUserType4user = (user) ->
            $filters=
                userTypeID: user['userTypeID']
            $http({ url: REST_API.hostname+"/server/ajax/userType/get.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.currentUser['userType']=postResponse['0']

        $scope.login = ->
            LoginService.login($scope.credentials)
            .then ((user) ->

                if (user!=undefined)
                    logger.logSuccess("Bienvenido a Samsung caYca Compresores!") 
                    $rootScope.$broadcast AUTH_EVENTS.loginSuccess
                    # console.log "SignIn Success!"
                    # getting Aditional Info... 
                    getCountry4user(user)
                    getCompany4user(user)
                    getUserType4user(user)
                    getCity4user(user)
                    $scope.setCurrentUser user
                    $location.path('/dashboard') 
                else
                    console.log "SingIn Error."
                    $rootScope.$broadcast AUTH_EVENTS.loginFailed
                    logger.logError('Usuario o contraseña invalida.')
                return
            )
            # Sirve BUT habria que cambiar REST service
            # ), ->
            #     console.log "credentials Error"
            #     return
            
        return #END LOGIN

        return #END Ctrl


        # $scope.login = (credentials) ->
        #     AuthService.login(credentials).then ((user) ->
        #         $rootScope.$broadcast AUTH_EVENTS.loginSuccess
        #         $scope.setCurrentUser user
        #     return
        #     ), ->
        #         $rootScope.$broadcast AUTH_EVENTS.loginFailed
        #         return
        #     return

            
            # .then ((user) ->
            #     console.log "Exito"
            #     # console.log "Hola: "+ user.fullName
            #     # $rootScope.$broadcast AUTH_EVENTS.loginSuccess
            #     # $scope.setCurrentUser user
            #     return
            # ), -> #ELSE
            #     console.log "Fail Loging in"
            #     # $rootScope.$broadcast AUTH_EVENTS.loginFailed
            #     return #END ELSE


])  


.controller('NewAccountCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http ) ->
        console.log "@NewAccountCtrl 4 Mayor->GerenteComercial :)"
        # ng-model 4 user
        $scope.user = 
            userID: ''
            ID: ''
            userTypeSelected: ''
            fullName: ''
            email: ''
            address: ''
            phone: ''
            celphone: ''
            citySelected: ''
            companySelected: ''

        # var 4 select
        $scope.userTypes = []
        $scope.selected = undefined


        #Load companies
        getRetailerCompanies = ->
            $filters=
                isRetailer: true
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Company/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    # console.log postResponse
                    $scope.retailers =postResponse
            return
        getRetailerCompanies()


        # Load cities
        getCities = ->
            $filters=
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/City/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.cities = postResponse
        getCities()

        $scope.showInfoOnSubmit = false

        original = angular.copy($scope.user)

        $scope.revert = ->
            $scope.user = angular.copy(original)
            $scope.form_NewAccount.$setPristine()
            # $scope.form_NewAccount.confirmPassword.$setPristine()

        $scope.canRevert = ->
            return !angular.equals($scope.user, original) || !$scope.form_NewAccount.$pristine

        $scope.canSubmit = ->
            return $scope.form_NewAccount.$valid && !angular.equals($scope.user, original)

        $scope.submitForm = ->
             $scope.showInfoOnSubmit = true
             # $scope.revert()     
        
        #Load userTypes
        getUserType = ->
            $http.post(REST_API.hostname+"/server/ajax/Users/m_getUserType.php").success (data) ->
                $scope.userTypes = data
                $scope.user.userTypeSelected=data[0]
                return
            return
        getUserType()

        # Create New Account
        $scope.createNewAccount = ->
            # Defining my data Object
            $scope.user.password = generatePassword(6, false);
            # $scope.user.companySelected.companyID = null unless $scope.user.companySelected?
            # $scope.user.companySelected.companyID=null
            
            $scope.data = 
                userID : $scope.user.userID
                ID: $scope.user.ID
                email: $scope.user.email
                fullName: $scope.user.fullName
                password: $scope.user.password
                userTypeID: $scope.user.userTypeSelected.userTypeID
                geoID: $scope.user.citySelected.geoID
                companyID: $scope.user.retailerSelected.companyID
                address: $scope.user.address
                phone: $scope.user.phone
                celphone: $scope.user.celphone
            
            console.log ($scope.data)
            
            
            $http({ url: REST_API.hostname+"/server/ajax/Users/addUser.php", method: "POST", data: JSON.stringify($scope.data) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse.indexOf("ID") > -1)
                        console.log "Roy    : " + JSON.stringify(postResponse)
                        logger.logError "El usuario con cedula de idenficicación: " + $scope.data.ID + " ya está en la base de datos."
                    if (postResponse.indexOf("email") > -1)
                        console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "El usuario con ese EMAIL: " + $scope.data.email + " ya está en la base de datos."
                else
                    console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logSuccess "Se ha creado exitosamente el usuario: "+$scope.data.fullName
                    # logger.logWarning "Espere unos momentos se esta enviando el correo..."
                    $scope.revert()
                    #Sending Email
                    $http({ url: REST_API.hostname+"/server/ajax/Users/addUserConfirm.php", method: "POST", data: JSON.stringify($scope.data) })
                    .success (postResponseB) ->
                        console.log "Roy: " + JSON.stringify(postResponseB)
                        logger.logSuccess "Se ha enviado el correo con la información de registro a: "+ $scope.data.email
                    .error (postResponseB) ->
                        console.log "error enviando el correo"
                        logger.logError "Ha ocurrido un error enviando el correo. Por favor contacte al Administrador"
            .error (postResponse) ->
                console.log "error"                
])


.controller('NewTechnician', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http ) ->
        console.log "@NewTechnician :)"
# ng-model 4 user
        $scope.user = 
            ID: ''
            userTypeSelected: 'TEC'
            fullName: ''
            email: ''
            address: ''
            phone: ''
            celphone: ''
            citySelected: ''


        # Load cities
        getCities = ->
            $http({ url: REST_API.hostname+"/server/ajax/City/list.php", method: "POST" })
                .success (postResponse) ->
                    $scope.cities = postResponse
        getCities()

        $scope.showInfoOnSubmit = false

        original = angular.copy($scope.user)

        $scope.revert = ->
            $scope.user = angular.copy(original)
            $scope.form_NewAccount.$setPristine()

        $scope.canRevert = ->
            return !angular.equals($scope.user, original) || !$scope.form_NewAccount.$pristine

        $scope.canSubmit = ->
            return $scope.form_NewAccount.$valid && !angular.equals($scope.user, original)

        $scope.submitForm = ->
             $scope.showInfoOnSubmit = true
             $scope.revert()     

        # Create New Account
        $scope.createNewAccount = ->
            # Defining my data Object
            $scope.user.password = generatePassword(6, false);
            
            $scope.data = 
                email: $scope.user.email
                ID: $scope.user.ID
                fullName: $scope.user.fullName
                password: $scope.user.password
                address: $scope.user.address
                phone: $scope.user.phone
                celphone: $scope.user.celphone
                userTypeID: $scope.user.userTypeSelected
                geoID: $scope.user.citySelected.geoID
            
            # console.log ($scope.data)
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            
            $http({ url: REST_API.hostname+"/server/ajax/Users/addUser.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse.indexOf("ID") > -1)
                        console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "El usuario con cedula de idenficicación: " + $scope.data.ID + " ya está en la base de datos."
                    if (postResponse.indexOf("email") > -1)
                        console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "El usuario con ese EMAIL: " + $scope.data.email + " ya está en la base de datos."
                else
                    console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logSuccess "Se ha creado exitosamente el usuario: "+$scope.data.fullName
                    # logger.logWarning "Espere unos momentos se esta enviando el correo..."
                    $scope.revert()

                    #Sending Email
                    $http({ url: REST_API.hostname+"/server/ajax/Users/addUserConfirm.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
                    .success (postResponseB) ->
                        console.log "Roy: " + JSON.stringify(postResponseB)
                        logger.logSuccess "Se ha enviado el correo con la información de registro a: "+ $scope.data.email
                    .error (postResponseB) ->
                        console.log "error enviando el correo"
                        logger.logError "Ha ocurrido un error enviando el correo. Por favor contacte al Administrador"

            .error (postResponse) ->
                console.log "error"                

                # logger.logSuccess('Se ha creado exitosamente la cuenta.')
            return
        return        
        
])

.controller('listSellersCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'listSellersCtrl'

        $scope.sellers = []
        $scope.searchKeywords = ''
        $scope.filteredSellers = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageSellers = $scope.filteredSellers.slice(start, end)

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
            $scope.filteredSellers = $filter('filter')($scope.sellers, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredSellers = $filter('orderBy')($scope.sellers, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageSellers = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        #Load companies
        getSellers = ->
            $filters=
                userTypeID: 'DV%'
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Users/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    console.log postResponse
                    $scope.sellers =postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDsellerUP').trigger('click')
                    if $scope.filteredSellers.length==0
                        logger.logError "No se encontraron vendedores registradas en su pais."
                    else
                        logger.logSuccess "Tiene "+$scope.sellers.length+" vendedores registrados."
                , 100
            return
        getSellers()

       

])


.controller('retailerRequestCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http ) ->
        console.log "@retailerRequestCtrl 4 every1 :)"
        # ng-model 4 user
        $scope.company = 
            NIT: ''
            owner: ''
            email: ''
            address: ''
            phone: ''
            citySelected: ''

        # var 4 select
        $scope.selected = undefined

        # Load cities
        getCities = ->
            $http({ url: REST_API.hostname+"/server/ajax/City/list.php", method: "POST" })
                .success (postResponse) ->
                    $scope.cities = postResponse
        getCities()

        $scope.showInfoOnSubmit = false

        original = angular.copy($scope.company)

        $scope.revert = ->
            $scope.company = angular.copy(original)
            $scope.form_retailerRequest.$setPristine()

        $scope.canRevert = ->
            return !angular.equals($scope.company, original) || !$scope.form_retailerRequest.$pristine

        $scope.canSubmit = ->
            return $scope.form_retailerRequest.$valid && !angular.equals($scope.company, original)

        $scope.submitForm = ->
             $scope.showInfoOnSubmit = true
             # $scope.revert()     
])