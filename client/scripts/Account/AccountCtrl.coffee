'use strict'

angular.module('app.account.ctrls', [])

.controller('LoginCtrl', [
    'REST_API','AUTH_EVENTS','$scope', '$http', 'LoginService', 'logger', '$rootScope', '$location'
    (REST_API,AUTH_EVENTS, $scope, $http, LoginService, logger, $rootScope, $location) ->
        console.log "@LoginCtrl :)"
        $scope.credentials = 
            email:   ""
            password:   ""

        $scope.country4user=null
        $scope.company4user=null


        original = angular.copy($scope.credentials)

        $scope.canSubmit = ->
            return $scope.form_Login.$valid && !angular.equals($scope.credentials, original)

        # # get Country4User
        # getCountry4user = ->
        #     $http.post(REST_API.hostname+"/server/ajax/Country/getByID.php").success (data) ->
        #         $scope.country4user = data


        # # get company4User
        # getCountries = ->
        #     $http.post(REST_API.hostname+"/server/ajax/Company/getByID.php").success (data) ->
        #         $scope.company4user = data

        # # get City4User
        # getCountries = ->
        #     $http.post(REST_API.hostname+"/server/ajax/Tables/getCountry.php").success (data) ->
        #         $scope.countries = data

        # # get userType4User
        # getCountries = ->
        #     $http.post(REST_API.hostname+"/server/ajax/Tables/getCountry.php").success (data) ->
        #         $scope.countries = data

        $scope.login = ->
            LoginService.login($scope.credentials)
            .then ((user) ->

                if (user!=undefined)
                    console.log "SignIn Success."
                    console.log (user)
                    # $http.post(REST_API.hostname+"/server/ajax/Country/getByID.php").success (data) ->
                    #     $scope.country4user = data
                    logger.logSuccess("Bienvenido a Samsung caYca Compresores!") 
                    $rootScope.$broadcast AUTH_EVENTS.loginSuccess
                    $scope.setCurrentUser user,null,null,null,null
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
            $http.post(REST_API.hostname+"/server/ajax/Tables/getRetailerCompanies.php").success (data) ->
                $scope.retailers = data
                return
            return
        getRetailerCompanies()

         #Load cities
        getCities = ->
            $http.post(REST_API.hostname+"/server/ajax/Tables/getCity.php").success (data) ->
                $scope.cities = data
                return
            return
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
             $scope.revert()     
        
        #Load userTypes
        getUserType = ->
            $http.post(REST_API.hostname+"/server/ajax/Users/m_getUserType.php").success (data) ->
                $scope.userTypes = data
                return
            return
        getUserType()

        # Create New Account
        $scope.createNewAccount = ->
            # Defining my data Object
            $scope.user.password = generatePassword(18, false);
            # $scope.user.companySelected.companyID = null unless $scope.user.companySelected?


            # $scope.user.companySelected.companyID=null
            

            $scope.data = 
                ID: $scope.user.ID
                email: $scope.user.email
                fullName: $scope.user.fullName
                password: $scope.user.password
                userTypeID: $scope.user.userTypeSelected.userTypeID
                geoID: $scope.user.citySelected.geoID
                companyID: $scope.user.companySelected.companyID
            # console.log $scope.user.email + " " + $scope.user.password
            console.log ($scope.data)
            # $scope.data["countrySelected"] = $scope.countrySelected
            # $scope.data["serialsSelected"] = $serialsWithoutNo
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            # console.log ($scope.data)
            $http({ url: REST_API.hostname+"/server/ajax/Users/addUser.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                console.log "success postResponse: " + (postResponse)
                console.log "success stringify: " + JSON.stringify(postResponse)
                logger.logSuccess('Se ha creado exitosamente la cuenta.')
            return
        return
        
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


        #Load cities
        getCities = ->
            $http.post(REST_API.hostname+"/server/ajax/Tables/getCity.php").success (data) ->
                $scope.cities = data
                return
            return
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
            $scope.user.password = generatePassword(18, false);
            
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