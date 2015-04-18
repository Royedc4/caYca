'use strict';

angular.module('app.raffles.ctrls', [])

# Roy
# Controllers for 

.controller('newCouponCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'newCouponCtrl'

        # Alert Message
        $scope.alerts = [
            { type: 'info', msg: 'TIPS: Escriba unicamente las letras o numeros, no es necesario escribir los guiones. ni seleccionar el siguiente campo de texto, el formulario va haciendo todo automáticamente.' }
        ]
        $scope.closeAlert = (index)->
            $scope.alerts.splice(index, 1)

        #Array of Inputs
        $scope.inputs = []
        #Selected Quantity
        $scope.quantity = 1
        
        # Debuging Purposes only
        $scope.roYTesting = ->
            preparingData()
            console.log ">>$scope.data2insert>>"
            console.log $scope.data2insert

        
        # Form Manipulation
        $scope.revert = ->
            $scope.data2insert=
                token: []
                userID: ''
                country: ''
                userTypeID: ''
                createdBy: ''
            $scope.loadInputs()
            preparingData()
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
            setTimeout ->
                    logger.log("Se ha preparado el formulario. Proceda a ingresar los tokens.") 
                , 2000
            
        
        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $scope.data2insert=
                token: []
                userID: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                userTypeID: $scope.currentUser.userType.userTypeID
                createdBy: $scope.currentUser.userID

            for i in [1...$scope.quantity+1] by 1
                # console.log "input#"+i+ " = " + angular.uppercase document.getElementById('input'+i).value
                $scope.data2insert['token'].push(angular.uppercase document.getElementById('input'+i).value)

        # registerToken4raffle
        $scope.registerToken4raffle = ->
            preparingData()
            $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/add.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                console.log postResponse
                if (typeof postResponse) == "object"
                    for i in [1...postResponse['errorsArray'].length] by 1
                        if (postResponse['errorsArray'][i].indexOf("raffleID")!=-1)
                            logger.logError "No se encuentran tokens disponibles para su país."
                        if (postResponse['errorsArray'][i].indexOf("fk_raffleCoupons_labeledSerials1")!=-1)
                            logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
                        if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
                            logger.logError "Ingresaste un token ya registrado!"
                        if postResponse['zGlobalResult']
                            logger.logSuccess "Has registrado Exitosamente " + ((postResponse['arrayQueries'].length)-1).toString() + " Tokens en tu cuenta!"
                            $scope.revert()
])

.controller('listCouponsCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'listCouponsCtrl'

        $scope.raffleCoupons = []
        $scope.searchKeywords = ''
        $scope.filteredRaffleCoupons = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRaffleCoupons = $scope.filteredRaffleCoupons.slice(start, end)

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
            $scope.filteredRaffleCoupons = $filter('filter')($scope.raffleCoupons, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRaffleCoupons = $filter('orderBy')($scope.raffleCoupons, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageRaffleCoupons = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        # Getting raffleCoupons4user
        raffleCoupons4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.raffleCoupons=postResponse
                # console.log postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDRaffleUP').trigger('click')
                    if $scope.filteredRaffleCoupons.length==0
                        logger.logError "No se encontraron cupones registrados en su cuenta."
                    else
                        logger.logSuccess "Tiene "+$scope.filteredRaffleCoupons.length+" cupones de Rifa."
                , 100
                
        raffleCoupons4user()

])

.controller('resultsCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        # Definition of objets

        # Control Data
        
        # xD
        console.log 'resultsCtrl'

])