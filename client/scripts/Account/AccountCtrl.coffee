'use strict'

angular.module('app.account.ctrls', [])

.controller('LoginCtrl', [
    '$scope', '$http', 'LoginService'
    ($scope, $http, LoginService) ->
        console.log "@LoginCtrl :)"
        $scope.credentials = 
            email:   ""
            password:   ""

        original = angular.copy($scope.credentials)

        $scope.canSubmit = ->
            return $scope.form_Login.$valid && !angular.equals($scope.credentials, original)

        $scope.login = ->
            # console.log "HIT LOGIN :)"
            LoginService.login($scope.credentials)
            return

        return
])  


.controller('NewAccountCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http ) ->
        console.log "@NewAccountCtrl :)"
        # ng-model 4 user
        $scope.user = 
            fullName: ''
            email: ''
            userTypeSelected: ''
            password: ''

        # var 4 select
        $scope.userTypes = []

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
            $http.post("http://cayca:8888/server/ajax/Users/getUserType.php").success (data) ->
                $scope.userTypes = data
                return
            return
        getUserType()

        # Create New Account
        $scope.createNewAccount = ->
            # Defining my data Object
            $scope.user.password = generatePassword(18, false);
            $scope.data = 
                email: $scope.user.email
                fullName: $scope.user.fullName
                password: $scope.user.password
                userTypeID: $scope.user.userTypeSelected.userTypeID
            # console.log $scope.user.email + " " + $scope.user.password
            console.log ($scope.data)
            # $scope.data["countrySelected"] = $scope.countrySelected
            # $scope.data["serialsSelected"] = $serialsWithoutNo
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            # console.log ($scope.data)
            $http({ url: "http://cayca:8888/server/ajax/Users/addUser.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                console.log "success postResponse: " + (postResponse)
                console.log "success stringify: " + JSON.stringify(postResponse)
                logger.logSuccess('Se ha creado exitosamente la cuenta.')
            return
        return
        
])