'use strict';

angular.module('app.raffles.ctrls', [])

# Roy
# Controllers for 

.controller('newCouponCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'newCouponCtrl'
        $scope.canjeAutomatico = false
        $scope.oneAtATime = true
        $scope.raffleCoupons = []

        $scope.showInformation = ->
            if $scope.canjeAutomatico
                swal("Canje Automatico Activado!", "Los cupones que registres se canjearan automáticamente en su cuenta, puede ir a canjearlo en un punto de canje autorizado, para saber cuales son haga clic aquí.", "success")
            else
                swal("Canje Automatico Desactivado!", "Los cupones que registres no se canjearan automáticamente a tu cuenta, los podras entregar a otra persona para que los aproveche.", "error")
            
        # Alert Message
        $scope.alerts = [
            { type: 'info', msg: 'TIPS: Escriba unicamente las letras o numeros, ni seleccionar el siguiente campo de texto, el formulario hace todo automáticamente. El boton de Inscribir Tokens estará disponible cuando se ingresen todos los tokens.' }
        ]
        $scope.closeAlert = (index)->
            $scope.alerts.splice(index, 1)

        #Array of Inputs
        $scope.inputs = []
        #Selected Quantity
        $scope.quantity = 0
        
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
                , 500
            
        
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
            swal {
                    title: 'Confirmación de inscripción en Rifa'
                    text: '\nSeguro que quiere inscribir: # tokens a su nombre\nTienes activado el canje automatico, si lo quieres desactivar cancela y desactiva el boton.\n\nEste proceso es totalmente irreversible!'
                    type: 'warning'
                    showCancelButton: true
                    confirmButtonText: "Si, Inscribir!"
                    cancelButtonText: "No, cancelar!"
                    closeOnConfirm: false
                    closeOnCancel: false
                }, (isConfirm) ->
                        if isConfirm
                            swal 'Operación Procesada!', 'Se inscribieron exitosamente equiz cupones!', 'success'
                        else
                            swal 'Operación Cancelada', 'Todo bien, no se han inscrito tus cupones!', 'error'
                        return
            # preparingData()
            # $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            # .success (postResponse) ->
            #     console.log postResponse
            #     if (typeof postResponse) == "object"
            #         for i in [1...postResponse['errorsArray'].length] by 1
            #             if (postResponse['errorsArray'][i].indexOf("raffleID")!=-1)
            #                 logger.logError "No se encuentran tokens disponibles para su país."
            #             if (postResponse['errorsArray'][i].indexOf("fk_raffleCoupons_labeledSerials1")!=-1)
            #                 logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
            #             if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
            #                 logger.logError "Ingresaste un token ya registrado!"
            #             if (postResponse['errorsArray'][i].indexOf("vendido")!=-1)
            #                 logger.logError "El token #: "+i+" ("+postResponse['arrayQueries'][i].substring(26, 40)+"), no ha sido vendido por ningun detal."
            #             if postResponse['zGlobalResult']
            #                 logger.logSuccess "Has registrado Exitosamente " + ((postResponse['arrayQueries'].length)-1).toString() + " Tokens en tu cuenta!"
            # if $scope.canjeAutomatico
            #     setTimeout ->
            #         console.log "Tambien se canjeara el cupon."
            #         # registerToken4redeem
            #         $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            #         .success (postResponse) ->
            #             console.log postResponse
            #             if (typeof postResponse) == "object"
            #                 for i in [1...postResponse['errorsArray'].length] by 1
            #                     if (postResponse['errorsArray'][i].indexOf("redeemID")!=-1)
            #                         logger.logError "No se encuentran tokens disponibles para su país."
            #                     if (postResponse['errorsArray'][i].indexOf("fk_redeemCoupons_labeledSerials1")!=-1)
            #                         logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
            #                     if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
            #                         logger.logError "Ingresaste un token ya registrado!"
            #                     if postResponse['zGlobalResult']
            #                         logger.logSuccess "Tambien registraste " + ((postResponse['arrayQueries'].length)-1).toString() + " Tokens para canjes!"
            #     , 1000
            # $scope.revert()
            # setTimeout (->
            #     $scope.$apply ->
            #         raffleCoupons4user()
            #         return
            #     return
            # ), 500


        # Getting raffleCoupons4user
        raffleCoupons4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/listByuserID.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.raffleCoupons=postResponse
        raffleCoupons4user()
])

.controller('listCouponsCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout', 'cfpLoadingBar'
    (REST_API,$scope, logger, $http, $filter, $timeout, cfpLoadingBar) ->
        console.log 'listCouponsCtrl'
        $scope.loadStatus

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
            $http({ url: REST_API.hostname+"/server/ajax/raffleCoupon/listByuserID.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.raffleCoupons=postResponse
                for i in [0...$scope.raffleCoupons.length] by 1
                    $scope.raffleCoupons[i]['creationDate']=moment($scope.raffleCoupons[i]['creationDate']).format("DD/MM/YYYY")
                $scope.init()
                $('#searchKeywords').focus()
                $scope.loadStatus=cfpLoadingBar.status()
                if $scope.filteredRaffleCoupons.length==0
                    logger.logError "No se encontraron cupones registrados en su cuenta."
                else
                    logger.logSuccess "Tiene "+$scope.filteredRaffleCoupons.length+" cupones de Rifa."
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


.controller('infoCtrl', [
    'REST_API','$scope', 'logger', '$http', '$modal', '$log'
    (REST_API,$scope, logger, $http, $modal, $log) ->
        console.log 'infoCtrl'
        $scope.open = ->
            modalInstance = $modal.open(
                templateUrl: "myModalContent.html"
                controller: 'ModalInstanceCtrl'
            )
            modalInstance.result.then ((selectedItem) ->
                console.log selectedItem
            ), ->
                $log.info "Modal dismissed at: " + new Date()
])

.controller('ModalInstanceCtrl', [
    '$scope', '$modalInstance'
    ($scope, $modalInstance) ->
        $scope.ok = ->
            $modalInstance.close "teterito"
            return

        $scope.cancel = ->
            $modalInstance.dismiss "cancel"
            return

        return
])