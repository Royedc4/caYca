'use strict'

angular.module('app.admin.ctrls', [])

.controller('LoginCtrlROY', [
    '$scope', '$http', 'LoginService'
    ($scope, $http, LoginService) ->
        console.log "@LoginCtrl :)"
        $scope.credentials = 
            email:   ""
            password:   ""
        $scope.login = ->
            console.log "HIT LOGIN :)"
            LoginService.login($scope.credentials)
            return
        return
])  