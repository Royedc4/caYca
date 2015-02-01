'use strict';

angular.module('app.account.services', [])

.factory('LoginService', [ 
    '$http', '$location', 'logger'
    ($http, $location, logger) ->
        login: (credentials) -> 
            console.log "LOGIN!"

            data = 
                email: credentials.email
                password: credentials.password
            
            console.log (data)
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            $http({ url: "http://cayca:8888/server/ajax/Users/getUser.php", method: "POST", data: JSON.stringify(JSON.stringify(data)) })
            .success (postResponse) ->
                # console.log "success NORMAL: " + (postResponse)
                if (postResponse[0]['loggedIn'])
                    console.log "SignIn Success: " + (postResponse)
                    console.log JSON.stringify(postResponse)
                    logger.logSuccess("Bienvenido a Samsung caYca") 
                    $location.path('/dashboard') 
                else
                    console.log "SingIn Error" + JSON.stringify(postResponse)
                    logger.logError('Usuario o Contraseña invalida.')
            return



            # console.log credentials.email + " " + credentials.password

            # if credentials.email is "R@oy" and credentials.password is "123"
            #     console.log "Logged"
            #     $location.path('/dashboard')
            # else
            #     console.log "NOT Logged"
            #     alert "Wrong baby Baby Baby ohoohoh!"
            return
        logout: ->
            console.log "Logged Out"
            $location.path('/pages/signin')
            return
])