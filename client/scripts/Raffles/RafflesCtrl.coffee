'use strict';

angular.module('app.raffles.ctrls', [])

# Roy
# Controllers for 

.controller('newCouponCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'newCouponCtrl'

        # Definition of objets

        #Array of Inputs
        $scope.inputs = []

        #Selected Quantity
        $scope.quantity = 1
        
        # Debuging Purposes only
        $scope.roYTesting = ->
            console.log ">>data2insert>>"
            console.log $data2insert
        
        # Form Manipulation
        $scope.revert = ->
            $scope.data2insert=
                token:[]
                userID: ''
                country: ''
                userTypeID: ''
                createdBy: ''
            $scope.loadInputs()
            $scope.serialsForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.serialsForm.$pristine
        $scope.canSubmit = ->
            return $scope.serialsForm.$valid 

        # Creation of Input Dinamically
        $scope.loadInputs = ->
            # 4not Adding more
            $scope.inputs = []
            i=0
            while i<($scope.quantity)
                j=i+1
                $scope.inputs.push({ placeholder: "Token # " + j})
                i++
            logger.log("Se ha preparado el formulario. Proceda a ingresar los tokens.") 

        # Preparing DATA 2 Insert
        $data2insert=
            token:[]
            userID: ''
            country: ''
            userTypeID: ''
            createdBy: ''
        
        # registerToken4raffle
        $scope.confirmLabels = ->
            preparingData()
            $http({ url: REST_API.hostname+"/server/ajax/labeledSerials/updateDate.php", method: "POST", data: JSON.stringify($data2insert) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse=="1")
                        logger.logSuccess "Ha concluido el etiquetado de " +$scope.data2label['serial'].length + " compresor(es)."
                        $scope.revert()
                    if (postResponse.indexOf("request")!=-1)
                        logger.logError "Debes solicitar las etiquetas antes de confirmar sus impresiones."
                    if (postResponse.indexOf("Labeled")!=-1)
                        logger.logWarning "Ya cumlminaste la impresion de la(s) " +$scope.data2label['serial'].length + " Etiqueta(s)."
                        $scope.revert()
                console.log postResponse

])

.controller('listCouponsCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'listCouponsCtrl'

])

.controller('resultsCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'resultsCtrl'

])