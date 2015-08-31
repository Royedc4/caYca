'use strict'

angular.module('app.admin.ctrls', [])

.controller('databaseJobsCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http ) ->
        console.log "@databaseJobsCtrl :)"

        $scope.specialProcess = ->
            console.log "HIT special :)"
            $http({ url: REST_API.hostname+"/server/ajax/Serials/FixingBills.php", method: "POST"})
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    console.log "Roy1: " + (postResponse)
                    logger.logSuccess "Se ha creado exitosamente la empresa: "
                else
                    console.log "Roy2: " + JSON.stringify(postResponse)
                    console.log "Roy2: " + (postResponse)
            .error (postResponse) ->
                console.log "error"
        $scope.magic = ->
            console.log "HIT magic :)"
        $scope.development = ->
            console.log "HIT development :)"
])  

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