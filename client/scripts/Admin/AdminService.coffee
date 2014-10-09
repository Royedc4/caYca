'use strict';

angular.module('app.admin.services', [])

.factory('LoginServiceROY', [ 
    '$location'
    ($location) ->
        login: (credentials) -> 
            if credentials.email is "R@oy" and credentials.password is "123"
                console.log "Logged"
                $location.path('/dashboard')
            else
                console.log "NOT Logged"
                alert "Wrong baby Baby Baby ohoohoh!"
            return
        logout: ->
            console.log "Logged Out"
            $location.path('/pages/signin')
            return
])