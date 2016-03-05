'use strict';

angular.module('app.controllers', [])

# overall control
.controller('AppCtrl', [
    '$scope', '$location', 'USER_ROLES', 'LoginService'
    ($scope, $location, USER_ROLES, LoginService) ->
        $scope.isSpecificPage = ->
            path = $location.path()
            return _.contains( [
                '/404'
                '/pages/500'
                '/pages/login'
                '/pages/signin'
                '/pages/signin1'
                '/pages/signin2'
                '/accounts/signIn'
                '/accounts/signUp'
                '/accounts/retailerRequest'
                '/pages/signup'
                '/pages/signup1'
                '/pages/signup2'
                '/pages/forgot'
                '/pages/lock-screen'
                '/landing/uno'
                '/landing/dos'
                '/landing'
                '/roy/code'
                '/accounts/confirmContact'
            ], path )

        $scope.main =
            brand: 'SAMSUNG'
            name: 'Usuario caYca' # those which uses i18n can not be replaced for now.

        $scope.currentUser = null

        $scope.userRoles = USER_ROLES
        $scope.isAuthorized = LoginService.isAuthorized

        $scope.setCurrentUser = (user) ->
            $scope.currentUser=user
            console.log $scope.currentUser
            return

        $scope.logOut = () ->
            LoginService.logout()
            $location.path "/accounts/signIn"
            return

])

.controller('NavCtrl', [
    '$scope', 'taskStorage', 'filterFilter'
    ($scope, taskStorage, filterFilter) ->
        # init
        tasks = $scope.tasks = taskStorage.get()
        $scope.taskRemainingCount = filterFilter(tasks, {completed: false}).length

        $scope.$on('taskRemaining:changed', (event, count) ->
            $scope.taskRemainingCount = count
        )

])

.controller('DashboardCtrl', [
    'REST_API','AUTH_EVENTS','$scope', '$http', 'LoginService', 'logger', '$rootScope', '$location', 'cfpLoadingBar'
    (REST_API,AUTH_EVENTS, $scope, $http, LoginService, logger, $rootScope, $location, cfpLoadingBar) ->
        console.log "On DashboardCtrl"

        if ($scope.currentUser.userTypeID=='TEC' || $scope.currentUser.userTypeID=='DV' || $scope.currentUser.userTypeID=='DVC')
            console.log('widgets4tecsAndSellers')
            # Loading user-redeemableMoney
            redeemableMoney = ->
                $filters=
                    userID: $scope.currentUser.userID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/user-redeemableMoney.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.redeemableMoney = postResponse['0'].redeemableMoney
                        if $scope.redeemableMoney==null
                            $scope.redeemableMoney=0
            redeemableMoney()

            # Loading user-redeemablePoints
            redeemablePoints = ->
                $filters=
                    userID: $scope.currentUser.userID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/user-redeemablePoints.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.redeemablePoints = postResponse['0'].redeemablePoints
                        if $scope.redeemablePoints==null
                            $scope.redeemablePoints=0
            redeemablePoints()

            # Loading user-raffleCoupons
            raffleCoupons = ->
                $filters=
                    userID: $scope.currentUser.userID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/user-raffleCoupons.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.raffleCoupons = postResponse['0'].coupons
            raffleCoupons()
        if ($scope.currentUser.userTypeID=='MOC')
            console.log('widgets4moc')
        else
            console.log('widgets4companiesUsers')
            # Widgets Data
            $scope.salesProgressPieChart =
                percent: 1
                options:
                    animate:
                        duration: 4250
                        enabled: true
                    barColor: '#66B5D7'
                    lineCap: 'round'
                    size: 180
                    lineWidth: 10

            $scope.labelingProgressPieChart =
                percent: 1
                options:
                    animate:
                        duration: 4250
                        enabled: true
                    barColor: '#31C0BE'
                    lineCap: 'round'
                    size: 180
                    lineWidth: 12

            $scope.donutDataRec = null
            $scope.donutDataRot = null

            $scope.companyStockrec=[]
            $scope.companyStockrot=[]
            # Load companyStock
            getCompanyStock = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                    idFamily: 1
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/companyStock.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        postResponse.forEach (item) ->
                            # Temp Fix 4 Gallium Disorder...
                            # 11/29/15 Roy.
                            if item['compressorID']=='MSA143C-S1A'
                                 item['stock']=parseInt(item['stock'])-1
                            if item['compressorID']=='MD152C-L1UB'
                                 item['stock']=parseInt(item['stock'])-2
                            if item['compressorID']=='MSA170C-L1B'
                                 item['stock']=parseInt(item['stock'])-1
                            if item['compressorID']=='MK183D-L2UB'
                                 item['stock']=parseInt(item['stock'])+1
                            if item['compressorID']=='SK1A1C-L2WB'
                                 item['stock']=parseInt(item['stock'])-1
                            $scope.companyStockrec.push({ label:item['compressorID'], value: parseInt(item['stock'])})
                            $scope.donutDataRec = $scope.companyStockrec
                # Another Chart
                $filters=
                    companyID: $scope.currentUser.companyID
                    idFamily: 2
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/companyStock.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        postResponse.forEach (item) ->
                            # Temp Fix 4 Gallium Disorder...
                            # 11/29/15 Roy.
                            if item['compressorID']=='UR4B110IXBJL'
                                 item['stock']=parseInt(item['stock'])-2
                            if item['compressorID']=='UR8C172INCJH'
                                 item['stock']=parseInt(item['stock'])-2
                            if item['compressorID']=='UG8C180IUAJH'
                                 item['stock']=parseInt(item['stock'])+3
                            $scope.companyStockrot.push({ label:item['compressorID'], value: parseInt(item['stock'])})
                            $scope.donutDataRot = $scope.companyStockrot
            getCompanyStock()

            # Load companyStock
            getCompanySales = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/companySales.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.companySales = postResponse

            getCompanySales()
            # Load companyStock
            getLabelingProgress = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/labelingProgress.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.labelingProgressPieChart =
                            percent: postResponse[0].porcentaje

            getLabelingProgress()
            # Load companyStock
            getSalesProgress = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/salesProgress.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.salesProgressPieChart =
                            percent: postResponse[0].porcentaje
            getSalesProgress()
])
