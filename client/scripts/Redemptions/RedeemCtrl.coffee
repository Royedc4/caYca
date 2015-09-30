'use strict'

angular.module('app.redemptions.ctrls', [])

# Roy
# Controllers for redemptions

.controller('sellerCtrl', [
    'REST_API','$scope', 'logger', '$http', '$location'
    (REST_API,$scope, logger, $http, $location) ->
        console.log 'sellerCtrl'
        $scope.forms = {}

        #Array of Inputs
        $scope.inputs = []
        #Selected Quantity
        $scope.quantity = 0
        $scope.redeemedArticle= ''
        
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
            $scope.forms.tokensRedeemForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.forms.tokensRedeemForm.$pristine
        $scope.canSubmit = ->
            return $scope.forms.tokensRedeemForm.$valid 

        # Creation of Input Dinamically
        $scope.loadInputs = ->
            console.log "loadInputs"        
            # 4not Adding more
            $scope.inputs = []
            i=0
            while i<($scope.forms.quantity)
                j=i+1
                $scope.inputs.push({ placeholder: "Token # " + j})
                i++
            setTimeout ->
                    logger.log("Se ha preparado el formulario. Proceda a ingresar los tokens.") 
                , 1000
        
        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $scope.data2insert=
                token: []
                userID: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                userTypeID: $scope.currentUser.userType.userTypeID
                createdBy: $scope.currentUser.userID

            for i in [1...$scope.forms.quantity+1] by 1
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
                            redeemableStuff()
                            $scope.revert()

        # Widget
        redeemableStuff = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/Widgets/user-redeemableStuff.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.redeemableStuff = postResponse['0']
                    # console.log $scope.redeemableStuff
                    if $scope.redeemableStuff==null
                        $scope.redeemableStuff.points=0
        redeemableStuff()

        # Redeems
        $scope.reachableItems = []
        $scope.forms.itemSelected=''

        preparingData4redemption = ->
            $scope.data2insert=
                itemID: $scope.forms.itemSelected.itemID
                userID: $scope.currentUser.userID
                createdBy: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                comment: ''
                points: null

        # registerRedemption
        $scope.registerRedemption = ->
            preparingData4redemption()
            $http({ url: REST_API.hostname+"/server/ajax/redeems/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                console.log postResponse
                if (typeof postResponse) == "object"
                    if postResponse['results']['enoughPoints']=='1'
                        redeemableStuff()
                        reachableItems4user()
                        setTimeout ->
                            logger.logSuccess "Has registrado Exitosamente el canje #"+ postResponse['results']['nextAi']+" por un " + $scope.forms.itemSelected.name + " !"    
                            $scope.forms.itemSelected=''
                        , 750
                        
                        
        # Getting reachableItems4user
        reachableItems4user = ->
            $filters=
                userID: $scope.currentUser.userID
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Item/reachability.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.reachableItems=postResponse
        reachableItems4user()
])






.controller('changeStatusCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        console.log 'changeStatusCtrl'

        $scope.redeems = []
        $scope.searchKeywords = ''
        $scope.filteredRedeems = []
        $scope.row = ''

        # 4newStatus disabled
        $scope.newStatus=null

        $scope.seleccionada=null
        $scope.selectedRow=null

        $scope.getInfo = (index) ->
            $scope.selectedRow = index;
            console.log(this.redeem)
            $scope.seleccionada=this.redeem


        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRedeems = $scope.filteredRedeems.slice(start, end)

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
            $scope.filteredRedeems = $filter('filter')($scope.redeems, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRedeems = $filter('orderBy')($scope.redeems, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[0]
        $scope.currentPage = 1
        $scope.currentPageRedeems = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        getStatus = ->
            $http({ url: REST_API.hostname+"/server/ajax/redeems/getStatus.php", method: "POST"})
            .success (postResponse) ->
                console.log postResponse
                $scope.possibleStatus=postResponse
        getStatus()

        $scope.getSellersRedeems = ->
            $filters=
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/redeems/lists2update.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.redeems=postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    # $('#searchKeywords').focus()
                    angular.element('#orderIDRedeemUP').trigger('click')
                    angular.element('#orderIDRedeemDW').trigger('click')
                , 250

                if $scope.redeems['0']!=null
                    for i in [0...$scope.redeems.length] by 1
                        $scope.redeems[i]['creationDate']=moment($scope.redeems[i]['creationDate']).format("DD/MM/YYYY")
                else
                    $scope.redeems=[]                
        $scope.getSellersRedeems()

        $scope.changeStatus = ->
            $filters=
                newStatusID: $scope.newStatus.redeemStatusID
                redemptionID: $scope.seleccionada.redemptionID
            # console.log "Cambiando el " + $scope.seleccionada.redemptionID + ", A: " + $scope.newStatus.description
            $http({ url: REST_API.hostname+"/server/ajax/redeems/newStatus.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                console.log postResponse
                $scope.getSellersRedeems()
])











.controller('listCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        console.log 'listCtrl'

        $scope.redeemCoupons = []
        $scope.searchKeywords = ''
        $scope.filteredRedeemCoupons = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRedeemCoupons = $scope.filteredRedeemCoupons.slice(start, end)

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
            $scope.filteredRedeemCoupons = $filter('filter')($scope.redeemCoupons, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRedeemCoupons = $filter('orderBy')($scope.redeemCoupons, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageRedeemCoupons = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        # Getting redeemCoupons4user
        redeemCoupons4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/redeems-list.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.redeemCoupons=postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDRedeemUP').trigger('click')
                    if (typeof $scope.redeemCoupons['0'] == 'undefined')
                        logger.logError "No se encontraron canjes registrados en su cuenta."
                    else
                        logger.logSuccess "Tiene "+$scope.redeemCoupons.length+" canjes."
                , 100

                if $scope.redeemCoupons['0']!=null
                    for i in [0...$scope.redeemCoupons.length] by 1
                        $scope.redeemCoupons[i]['creationDate']=moment($scope.redeemCoupons[i]['creationDate']).format("DD/MM/YYYY")
                else
                    $scope.redeemCoupons=[]                
        redeemCoupons4user()
])







.controller('pointsCtrl', [
    'REST_API','$scope', 'logger', '$http','$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        console.log 'pointsCtrl'

        $scope.redeemCoupons = []
        $scope.searchKeywords = ''
        $scope.filteredRedeemCoupons = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRedeemCoupons = $scope.filteredRedeemCoupons.slice(start, end)

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
            $scope.filteredRedeemCoupons = $filter('filter')($scope.redeemCoupons, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRedeemCoupons = $filter('orderBy')($scope.redeemCoupons, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageRedeemCoupons = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        # Getting redeemCoupons4user
        redeemCoupons4user = ->
            $filters=
                userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/redeemCoupon/redeems-avaiablePoints.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.redeemCoupons=postResponse
                for i in [0...$scope.redeemCoupons.length] by 1
                    $scope.redeemCoupons[i]['creationDate']=moment($scope.redeemCoupons[i]['creationDate']).format("DD/MM/YYYY")
            
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#orderIDRedeemUP').trigger('click')
                    if $scope.filteredRedeemCoupons.length==0
                        logger.logError "No se encontraron cupones registrados en su cuenta."
                    else
                        logger.logSuccess "Tiene "+$scope.filteredRedeemCoupons.length+" cupones de canje."
                , 100
                
        redeemCoupons4user()

])
















.controller('technicianCtrl', [
    'REST_API','$scope', 'logger', '$http', '$location'
    (REST_API,$scope, logger, $http, $location) ->
        console.log 'technicianCtrl'
        $scope.forms = {}
        $scope.technicianInfo=''
        $scope.maximito=5
        $scope.minimito=6

        $scope.redeemableStuff={}

        #Array of Inputs
        $scope.inputs = []
        #Selected Quantity
        $scope.quantity = 0

        # Getting consultID
        $scope.consultID = ->
            console.log "consultID"
            # getting userID for ID given
            $filters=
                ID: $scope.ID
            $http({ url: REST_API.hostname+"/server/ajax/Users/user-getInfo-fromID.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                if (typeof postResponse['0'])!='undefined'
                    if postResponse['0'].userTypeID=='TEC'
                        $scope.minimito=0 
                        $scope.technicianInfo=postResponse['0']
                        console.log postResponse['0']
                        # Widget: redeemableStuff
                        redeemableStuff = ->
                        $filters=
                            userID: $scope.technicianInfo.userID
                        $http({ url: REST_API.hostname+"/server/ajax/Widgets/user-redeemableStuff.php", method: "POST", data: JSON.stringify($filters) })
                            .success (postResponse) ->
                                console.log postResponse['0']
                                $scope.redeemableStuff = postResponse['0']
                                $scope.maximito=$scope.redeemableStuff.coupons
                        logger.log("Bienvenido: "+$scope.technicianInfo.fullName) 
                    else
                        logger.logError "La cedula: "+$scope.ID+", no pertenece a un tecnico!"    
                else
                    logger.logError "La cedula: "+$scope.ID+", no se encuentra registrada!"

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
            $scope.forms.tokensRedeemForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.forms.tokensRedeemForm.$pristine
        $scope.canSubmit = ->
            return $scope.forms.tokensRedeemForm.$valid && $scope.technicianInfo!=''

        # Creation of Input Dinamically
        $scope.loadInputs = ->
            console.log "loadInputs"        
            # 4not Adding more
            $scope.inputs = []
            i=0
            while i<($scope.forms.quantity)
                j=i+1
                $scope.inputs.push({ placeholder: "Token # " + j})
                i++
            setTimeout ->
                    logger.log("Se ha preparado el formulario. Proceda a ingresar los tokens.") 
                , 1000
        
        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $scope.data2insert=
                token: []
                userID: $scope.technicianInfo.userID
                country: $scope.currentUser.country.country
                userTypeID: $scope.currentUser.userType.userTypeID
                createdBy: $scope.currentUser.userID

            for i in [1...$scope.forms.quantity+1] by 1
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
                            redeemableStuff()
                            $scope.revert()

        # Redeems
        $scope.reachableItems = []
        $scope.forms.itemSelected=''

        preparingData4redemption = ->
            console.log "money: " + $scope.redeemableStuff.moneyPerCoupon*$scope.forms.redeemedCoupons
            $scope.data2insert=
                itemID: 1
                userID: $scope.technicianInfo.userID
                createdBy: $scope.currentUser.userID
                country: $scope.currentUser.country.country
                comment: $scope.forms.redeemedArticle
                points: $scope.redeemableStuff.pointsPerCoupon*$scope.forms.redeemedCoupons


        # registerRedemption
        $scope.registerRedemption = ->
            preparingData4redemption()
            $http({ url: REST_API.hostname+"/server/ajax/redeems/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                console.log postResponse
                if (typeof postResponse) == "object"
                    if postResponse['results']['enoughPoints']=='1'
                        setTimeout ->
                            logger.logSuccess "Se ha registrado Exitosamente el canje #"+ postResponse['results']['nextAi']+" por un " + $scope.forms.redeemedArticle + " !"    
                            $scope.forms.itemSelected=''
                            $scope.consultID()
                            $scope.minimito=6
                        , 750
                    else
                        logger.logError "No tiene suficientes puntos para realizar este canje!"    


                        
])
