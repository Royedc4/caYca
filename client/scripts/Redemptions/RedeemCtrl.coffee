'use strict'

angular.module('app.redemptions.ctrls', [])

# Roy
# Controllers for redemptions

.controller('listCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'listCtrl'

])


.controller('pointsCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'pointsCtrl'

])

.controller('sellerCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'sellerCtrl'

        $scope.redeemCoupons = []
        $scope.reachableItems = []

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
            $scope.tokensRedeemForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.tokensRedeemForm.$pristine
        $scope.canSubmit = ->
            return $scope.tokensRedeemForm.$valid 

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

        # registerToken4redeem
        $scope.registerToken4redeem = ->
            preparingData()
            $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                console.log postResponse
                if (typeof postResponse) == "object"
                    for i in [1...postResponse['errorsArray'].length] by 1
                        if (postResponse['errorsArray'][i].indexOf("redeemID")!=-1)
                            logger.logError "No se encuentran tokens disponibles para su país."
                        if (postResponse['errorsArray'][i].indexOf("fk_redeemCoupons_labeledSerials1")!=-1)
                            logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
                        if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
                            logger.logError "Ingresaste un token ya registrado!"
                        if postResponse['zGlobalResult']
                            logger.logSuccess "Has registrado Exitosamente " + ((postResponse['arrayQueries'].length)-1).toString() + " Tokens en tu cuenta!"
                            $scope.revert()

        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $scope.data2insert=
                token: []
                userID: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                userTypeID: $scope.currentUser.userType.userTypeID
                createdBy: $scope.currentUser.userID

        # registerRedemption
        $scope.registerRedemption = ->
            preparingData4redemption()
            # $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            # .success (postResponse) ->
            #     console.log postResponse
            #     if (typeof postResponse) == "object"
            #         for i in [1...postResponse['errorsArray'].length] by 1
            #             if (postResponse['errorsArray'][i].indexOf("redeemID")!=-1)
            #                 logger.logError "No se encuentran tokens disponibles para su país."
            #             if (postResponse['errorsArray'][i].indexOf("fk_redeemCoupons_labeledSerials1")!=-1)
            #                 logger.logError "Ingresaste cupones invalidos. Intenta de nuevo!"
            #             if (postResponse['errorsArray'][i].indexOf("token_UNIQUE")!=-1)
            #                 logger.logError "Ingresaste un token ya registrado!"
            #             if postResponse['zGlobalResult']
            #                 logger.logSuccess "Has registrado Exitosamente " + ((postResponse['arrayQueries'].length)-1).toString() + " Tokens en tu cuenta!"
            #                 $scope.revert()


        # Getting redeemCoupons4user
        redeemCoupons4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/listByuserID.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                console.log postResponse
                $scope.redeemCoupons=postResponse
        redeemCoupons4user()

        $scope.itemSelected=null

        # Getting reachableItems4user
        reachableItems4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/Item/listReachable.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                console.log postResponse
                $scope.reachableItems=postResponse
        reachableItems4user()

])

.controller('technicianCtrl', [
     'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->
        console.log 'technicianCtrl'

])
