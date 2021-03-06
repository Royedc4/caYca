'use strict'

angular.module('app.account.ctrls', [])

.controller('forgotPassRequestCtrl', [
    'REST_API', '$scope', 'logger', '$http', '$location', '$routeParams', 'cfpLoadingBar'
    (REST_API, $scope, logger, $http, $location, $routeParams, cfpLoadingBar) ->
        $scope.requestReset = ->
            $filters=
                email: $scope.email
            $http({ url: REST_API.hostname+"/server/ajax/Users/f1Validation.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.emailValid=postResponse.emailAuthenticity
                    # console.log $scope.emailValid
                    if $scope.emailValid=='1'
                        console.log "::V::"
                        newToken=generatePassword(150, false)
                        #create password and insert into passwordchange... 
                        forgotRequestCreation = ->
                            $filters=
                                email: $scope.email
                                pToken: newToken
                            # console.log $filters
                            $http({ url: REST_API.hostname+"/server/ajax/Users/f2Creation.php", method: "POST", data: JSON.stringify($filters) })
                                .success (postResponse) ->
                                    # console.log postResponse
                                    if postResponse.operationResult=='1'
                                        #Send Email
                                        $data4email=
                                            fullName: postResponse.fullName
                                            email : $scope.email
                                            pToken: newToken
                                        # console.log $data4email
                                        $http({ url: REST_API.hostname+"/server/ajax/Users/mailPasswordForgot.php", method: "POST", data: JSON.stringify($data4email) })
                                        .success (postResponseB) ->
                                            logger.logSuccess "Se ha enviado el correo con la información para obtener su nueva clave a:\n"+ $scope.email
                                            $location.path('/landing')
                                        .error (postResponseB) ->
                                            # console.log "error enviando el correo"
                                            logger.logError "Ha ocurrido un error enviando el correo. Por favor contacte al Administrador"
                        forgotRequestCreation()
                    else
                        console.log "::I::"
                        document.getElementById('email').select()
                        logger.logError("Error. Verifique la direccion de correo.") 
                        
                    
])

.controller('forgotPassChangeCtrl', [
    'REST_API', '$scope', 'logger', '$http', '$location', '$routeParams', 'cfpLoadingBar'
    (REST_API, $scope, logger, $http, $location, $routeParams, cfpLoadingBar) ->
        $scope.tokenAuthenticity=''

        checkPasswordToken = ->
            $filters=
                pToken: $routeParams.pToken
            $http({ url: REST_API.hostname+"/server/ajax/Users/f3TokenVal.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.tokenAuthenticity=postResponse.tokenAuthenticity
        checkPasswordToken()

        $scope.canSubmit = ->
            return $scope.form_Login.$valid
        $scope.changePassword = ->
            $filters=
                pToken: $routeParams.pToken
                password: $scope.credentials.password
            $http({ url: REST_API.hostname+"/server/ajax/Users/f4changePass.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    # console.log postResponse
                    if postResponse.operationResult=='passwordUpdated'
                        logger.logSuccess("Ha cambiado exitosamente su clave, sera redirigido al inicio de sesion.")
                        $location.path('/accounts/signIn')
                    else
                        logger.logSuccess("No se ha logrado cambiar su clave, sera redirigido a olvido de contraseña.")
                        $location.path('/pages/forgot')
])

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
                    logger.logSuccess("Bienvenido a caYca SAMSUNG compresores") 
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
                ID: $scope.user.ID.toUpperCase()
                email: $scope.user.email
                fullName: $scope.user.fullName
                password: $scope.user.password
                userTypeID: $scope.user.userTypeSelected.userTypeID
                geoID: $scope.user.citySelected.geoID
                address: $scope.user.address
                phone: $scope.user.phone
                celphone: $scope.user.celphone

            if $scope.user.userTypeSelected.userTypeID !='DV' && $scope.user.userTypeSelected.userTypeID !='DVC'
                $scope.data["companyID"] = $scope.currentUser.company.companyID
            else
                $scope.data["companyID"] = $scope.user.retailerSelected.companyID
            
            # console.log ($scope.data)
            
            $http({ url: REST_API.hostname+"/server/ajax/Users/addUser.php", method: "POST", data: ($scope.data) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse.indexOf("ID") > -1)
                        # console.log "Roy    : " + JSON.stringify(postResponse)
                        logger.logError "El usuario con cedula de idenficicación: " + $scope.data.ID + " ya está en la base de datos."
                    if (postResponse.indexOf("email") > -1)
                        # console.log "Roy: " + JSON.stringify(postResponse)
                        logger.logError "El usuario con ese EMAIL: " + $scope.data.email + " ya está en la base de datos."
                else
                    # console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logSuccess "Se ha creado exitosamente el usuario: "+$scope.data.fullName
                    # logger.logWarning "Espere unos momentos se esta enviando el correo..."
                    $scope.revert()
                    #Sending Email
                    $http({ url: REST_API.hostname+"/server/ajax/Users/addUserConfirm.php", method: "POST", data: JSON.stringify($scope.data) })
                    .success (postResponseB) ->
                        # console.log "Roy: " + JSON.stringify(postResponseB)
                        logger.logSuccess "Se ha enviado el correo con la información de registro a: "+ $scope.data.email
                    .error (postResponseB) ->
                        # console.log "error enviando el correo"
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
                ID: $scope.user.ID.toUpperCase()
                fullName: $scope.user.fullName
                password: $scope.user.password
                address: $scope.user.address
                phone: $scope.user.phone
                celphone: $scope.user.celphone
                userTypeID: $scope.user.userTypeSelected
                geoID: $scope.user.citySelected.geoID
            
            # console.log ($scope.data)
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            
            $http({ url: REST_API.hostname+"/server/ajax/Users/addUser.php", method: "POST", data: (JSON.stringify($scope.data)) })
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
                    $http({ url: REST_API.hostname+"/server/ajax/Users/addUserConfirm.php", method: "POST", data: (JSON.stringify($scope.data)) })
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

.controller('listTechniciansCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout', 'cfpLoadingBar'
    (REST_API,$scope, logger, $http, $filter, $timeout, cfpLoadingBar) ->
        console.log 'listTechniciansCtrl'

        $scope.technicians = []
        $scope.searchKeywords = ''
        $scope.filteredTechnicians = []
        $scope.row = ''
        $scope.loadStatus=0

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageTechnicians = $scope.filteredTechnicians.slice(start, end)

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
            $scope.filteredTechnicians = $filter('filter')($scope.technicians, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredTechnicians = $filter('orderBy')($scope.technicians, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageTechnicians = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        #Load companies
        getTechnicians = ->
            cfpLoadingBar.start()
            $filters=
                userTypeID: 'TEC'
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Users/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.technicians =postResponse
                    cfpLoadingBar.complete()
                    $scope.loadStatus=cfpLoadingBar.status()
                    $scope.init()
                    if $scope.technicians.length==0
                        logger.logError "No se encontraron tecnicos registrados en su pais."
                    else
                        logger.logSuccess "Tiene "+$scope.technicians.length+" tecnicos registrados."
        getTechnicians()
])

.controller('listSellersCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout', 'cfpLoadingBar'
    (REST_API,$scope, logger, $http, $filter, $timeout, cfpLoadingBar) ->
        console.log 'listSellersCtrl'

        $scope.sellers = []
        $scope.searchKeywords = ''
        $scope.filteredSellers = []
        $scope.row = ''
        $scope.loadSellersStatus=0

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
            cfpLoadingBar.start()
            $filters=
                userTypeID: 'DV%'
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Users/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.sellers =postResponse
                    cfpLoadingBar.complete()
                    $scope.loadSellersStatus=cfpLoadingBar.status()
                    $scope.init()
                    if $scope.sellers.length==0
                        logger.logError "No se encontraron vendedores registrados en su pais."
                    else
                        logger.logSuccess "Tiene "+$scope.sellers.length+" vendedores registrados."
        getSellers()
])


.controller('retailerRequestCtrl', [
    'REST_API','$scope', 'logger', '$http', '$location'
    (REST_API,$scope, logger, $http, $location) ->
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

        # Request Contact
        $scope.requestContact = ->
            $scope.data = 
                businessName: $scope.company.businessName
                owner: $scope.company.owner
                contactName: $scope.company.contactName
                NIT: $scope.company.NIT
                email: $scope.company.email
                phone: $scope.company.phone
                celphone: $scope.company.celphone
                geoID: $scope.company.citySelected.geoID
                geoName: $scope.company.citySelected.name
            
            console.log ($scope.data)
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            
            $http({ url: REST_API.hostname+"/server/ajax/Company/retailerRequestMail.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                console.log postResponse
                logger.logSuccess('Gracias por su interes, será contactado proximamente.')
                $location.path('/accounts/confirmContact')
            .error (postResponse) ->
                console.log "error"                
                logger.logError "error"

])