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
                '/pages/signup'
                '/pages/signup1'
                '/pages/signup2'
                '/pages/forgot'
                '/pages/lock-screen'
            ], path )

        $scope.main =
            brand: 'SAMSUNG'
            name: 'Roy Calderón' # those which uses i18n can not be replaced for now.

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
    'REST_API','AUTH_EVENTS','$scope', '$http', 'LoginService', 'logger', '$rootScope', '$location'
    (REST_API,AUTH_EVENTS, $scope, $http, LoginService, logger, $rootScope, $location) ->

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

        $scope.donutData = [
            {label: 'Cargando Compresores', value: 1 }
            
        ]
        
        $scope.companyStock=[]

        console.log "On DashboardCtrl"
        if ($scope.currentUser.userTypeID=='TEC' || $scope.currentUser.userTypeID=='DV' || $scope.currentUser.userTypeID=='DVC')
            console.log('Cosas de tecnico') 
        else    
            console.log('Loading widgets4companiesUsers') 
            # Load companyStock
            getCompanyStock = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/companyStock.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        postResponse.forEach (item) ->
                            $scope.companyStock.push({ label:item['compressorID'], value: parseInt(item['stock'])})
                        setTimeout (->
                            $scope.$apply ->
                                $scope.donutData = $scope.companyStock
                                return
                                return
                                ), 500
            getCompanyStock()
            # Load companyStock
            getCompanySales = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/companySales.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.companySales = postResponse
                        console.log $scope.companySales
            getCompanySales()
            # Load companyStock
            getLabelingProgress = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/labelingProgress.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.labelingProgress = postResponse
                        setTimeout (->
                            $scope.$apply ->
                                $scope.labelingProgressPieChart = 
                                    percent: $scope.labelingProgress[0].porcentaje
                                return
                                return
                                ), 1500 
            getLabelingProgress()
            # Load companyStock
            getSalesProgress = ->
                $filters=
                    companyID: $scope.currentUser.companyID
                $http({ url: REST_API.hostname+"/server/ajax/Widgets/salesProgress.php", method: "POST", data: JSON.stringify($filters) })
                    .success (postResponse) ->
                        $scope.salesProgress = postResponse
                        setTimeout (->
                            $scope.$apply ->
                                $scope.salesProgressPieChart = 
                                    percent: $scope.salesProgress[0].porcentaje
                                return
                                return
                                ), 1500 
            getSalesProgress()


])
