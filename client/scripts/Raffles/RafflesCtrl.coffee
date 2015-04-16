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
            { type: 'info', msg: 'No es necesario escribir los guiones, al terminar de escribir cada token, presiona ENTER para pasar al siguiente rapidamente.' }
        ]
        $scope.closeAlert = (index)->
            $scope.alerts.splice(index, 1)

        #Array of Inputs
        $scope.inputs = []
        #Selected Quantity
        $scope.quantity = 1
        
        # Debuging Purposes only
        $scope.roYTesting = ->
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
            logger.log("Se ha preparado el formulario. Proceda a ingresar los tokens.") 
        
        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $scope.data2insert=
                token: []
                userID: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                userTypeID: $scope.currentUser.userType.userTypeID
                createdBy: $scope.currentUser.userID
        preparingData()

        # registerToken4raffle
        $scope.registerToken4raffle = ->
            $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/add.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    # if (postResponse=="1")
                    #     logger.logSuccess "Ha concluido el etiquetado de " +$scope.data2label['serial'].length + " compresor(es)."
                    #     $scope.revert()
                    if (postResponse.indexOf("raffleID")!=-1)
                        logger.logError "No se encuentran tokens dispnibles para su país."
                    if (postResponse.indexOf("fk_raffleCoupons_labeledSerials1")!=-1)
                        logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
                console.log postResponse

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
            # console.log $scope.filteredRaffleCoupons
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
                console.log postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDRaffleUP').trigger('click')
                , 100
                if $scope.filteredRaffleCoupons.length==0
                    logger.logError "No se encontraron cupones registrados en su cuenta."
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