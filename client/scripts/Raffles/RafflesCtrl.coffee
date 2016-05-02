'use strict';

angular.module('app.raffles.ctrls', [])

# Roy
# Controllers for

.controller('listAllInfoCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout', 'cfpLoadingBar'
    (REST_API,$scope, logger, $http, $filter, $timeout, cfpLoadingBar) ->
        console.log 'listAllInfoCtrl'
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
        $scope.numPerPageOpt = [3, 5, 10, 20, 50]
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
            $http({ url: REST_API.hostname+"/server/ajax/coupon/listByuserID.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.raffleCoupons=postResponse
                console.log postResponse
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


.controller('newCouponCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'newCouponCtrl'
        $scope.canjeAutomatico = false
        $scope.oneAtATime = true
        $scope.raffleCoupons = []

        $scope.showInformation = ->
            $scope.canjeAutomatico=!$scope.canjeAutomatico
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
            return $scope.serialsForm.$valid && $scope.inputs.length>0

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
            procesoMsg='Participara por la rifa y acumulara los puntos de sus cupones'
            endMsg='\n\nEste proceso es irreversible!'
            swal {
                    title: 'Confirmación de inscripción de cupon'
                    text: '\nSeguro que quiere inscribir: '+$scope.quantity+' tokens a su nombre\n\n'+procesoMsg+endMsg
                    type: 'warning'
                    showCancelButton: true
                    confirmButtonText: "Si... Inscribir!"
                    cancelButtonText: "No... Cancelar!"
                    closeOnConfirm: false
                    closeOnCancel: false
                }, (isConfirm) ->
                        if isConfirm
                            preparingData()
                            conPais=0
                            conInvalidos=0
                            conRepetidos=0
                            conNoVendido=0
                            conTipoUsuario=0
                            conBien=0
                            $http({ url: REST_API.hostname+"/server/ajax/coupon/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
                            .success (postResponse) ->
#                                console.log postResponse
                                if (typeof postResponse) == "object"
                                    for i in [0...postResponse['errorsArray'].length] by 1
                                        if (postResponse['errorsArray'][i].indexOf("raffleID")!=-1)
                                            conPais++
                                            logger.logError "No se encuentran tokens disponibles para su país."
                                        if (postResponse['errorsArray'][i].indexOf("existe")!=-1)
                                            conInvalidos++
                                            logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
                                        if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
                                            conRepetidos++
                                            logger.logError "Ingresaste un token ya registrado!"
                                        if (postResponse['errorsArray'][i].indexOf("usuario")!=-1)
                                            conTipoUsuario++
                                        if (postResponse['errorsArray'][i].indexOf("vendido")!=-1)
                                            conNoVendido++
                                            logger.logError "El token #: "+i+" ("+postResponse['arrayQueries'][i].substring(20, 34)+"), no ha sido vendido por ningun detal."
                                        if (postResponse['errorsArray'][i]=="20")
                                            conBien++
                                    if postResponse['zGlobalResult']
                                        logger.logSuccess "Has registrado Exitosamente " + ((postResponse['arrayQueries'].length)-1).toString() + " Cupones en tu cuenta!"
                                        swal 'Operación Procesada!', 'Se inscribieron exitosamente '+$scope.quantity+' cupones!', 'success'
                                    if conPais+conInvalidos+conRepetidos+conNoVendido==(postResponse['arrayQueries'].length)
                                        logger.logError "Tus cupones son invalidos!"
                                        console.log('conPais: '+conPais+', conInvalidos: '+conInvalidos+', conRepetidos: '+conRepetidos+', conNoVendido: '+conNoVendido)
                                        swal 'Operación No Procesada', 'Todos tus cupones son invalidos!', 'error'
                                    else
                                        if conTipoUsuario>0
                                            swal 'Operación No Procesada', 'Ingresaste un cupon que no es valido para tu usuario, este evento sera registrado!', 'error'
                                        if conPais>0 || conInvalidos>0 || conRepetidos>0 || conNoVendido>0
#                                            swal 'Advertencia', 'Hubo problemas con tus ' + ((postResponse['arrayQueries'].length)-1).toString() + ' Cupones:\nRegistrados exitosamente: '+conBien+'\nInvalidos: '+conInvalidos+'\nRepetidos: '+conRepetidos+'\nNoVendido: '+conNoVendido+'\nEste evento se ha registrado.', 'warning'
                                            swal title: "Resultado Inscripcion de Cupones", text: '<div class=row> <div class=col-sm-6> <div class="panel mini-box"> <span class="box-icon bg-danger"> <i class="fa fa-user-secret"></i> </span> <p class=size-h2>'+conNoVendido+'</p> <p class=text-muted> No vendido</p> </div> </div> <div class=col-sm-6> <div class="panel mini-box"> <span class="box-icon bg-danger"> <i class="fa fa-user-times"></i> </span> <p class=size-h2>'+conRepetidos+'</p> <p class=text-muted> Usado</p> </div> </div> </div> <div class=row> <div class=col-sm-6> <div class="panel mini-box"> <span class="box-icon bg-warning"> <i class="fa fa-times"></i> </span> <p class=size-h2>'+conInvalidos+'</p> <p class=text-muted> Invalidos</p> </div> </div> <div class=col-sm-6> <div class="panel mini-box"> <span class="box-icon bg-success"> <i class="fa fa-check"></i> </span> <p class=size-h2>'+conBien+'</p> <p class=text-muted> Registrados Exitosamente</p> </div> </div> </div> <blockquote class=text-center> Estos Eventos han quedado registrados. </blockquote>', html: true
                            $scope.revert()
                            setTimeout (->
                                $scope.$apply ->
                                    raffleCoupons4user()
                                    return
                                return
                            ), 500
                        else
                            swal 'Operación Cancelada', 'No se han inscrito tus cupones!', 'error'
                        return
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
