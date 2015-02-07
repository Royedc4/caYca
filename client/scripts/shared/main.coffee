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
        # ROY:
        $scope.rolIsAdmin=false

])

.controller('DashboardCtrl', [
    '$scope'
    ($scope) ->
        console.log "On DashboardCtrl"

])
