'use strict';

angular.module('app.account.services', [])

.service 'Session', ->

    #@ makes reference to this
    @create = (userID, email, userTypeID) ->
        @userID = userID
        @email = email
        @userTypeID = userTypeID
    return

    @destroy = ->
        @userID = null
        @email = null
        @userTypeID = null
    return

    return this 

.factory('LoginService', [
    '$http',  'logger', 'Session'
    ($http,  logger, Session) ->
        # !!Session.userID is equivalent to (Session.userID!=0) ? true : false)
        isAuthenticated: () ->
            return !!Session.userID

        isAuthorized: (authorizedRoles) ->
            if !angular.isArray(authorizedRoles)
                authorizedRoles = [authorizedRoles]
            if authorizedRoles.indexOf('ALL')!=-1
                return true
            else
                return authorizedRoles.indexOf(Session.userTypeID)!=-1
            # return isAuthenticated() && authorizedRoles.indexOf(Session.userTypeID)!=-1

        logout: () -> 
            logger.logSuccess 'Ha cerrado sesion.'
            Session.destroy
            return 
            

        login: (credentials) -> 
                return $http
                    .post('http://cayca:8888/server/ajax/Users/getUser.php', JSON.stringify(JSON.stringify(credentials)))
                    .then((res) ->
                        if (res.data[0]['loggedIn'])
                            # console.log "SignIn Success: "
                            Session.create(res.data[0]['0'].ID, res.data[0]['0'].email, res.data[0]['0'].userTypeID)
                            # logger.logSuccess("Bienvenido a Samsung caYca Compresores!") 
                            # $location.path('/dashboard') 
                        # else
                        #     # console.log "SingIn Error" 
                        #     # console.log "SingIn Error" + JSON.stringify(res)
                        #     # logger.logError('Usuario o Contraseña invalida.')
                        #     # console.log res
                        #     # console.log res.data[0]['0']
                        return res.data[0]['0'])

])

.factory('123LoginService', [ 
    '$http', '$location', 'logger', '$timeout'
    ($http, $location, logger, $timeout) ->
        login: (credentials) -> 
            console.log "LOGIN Service!"

            userDATA={}
            console.log credentials            
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            $http({ url: "http://cayca:8888/server/ajax/Users/getUser.php", method: "POST", data: JSON.stringify(JSON.stringify(credentials)) })
            .success (postResponse) ->
                # console.log "success NORMAL: " + (postResponse)
                if (postResponse[0]['loggedIn'])
                    console.log "SignIn Success: "
                    userDATA=postResponse[0]['0']
                    logger.logSuccess("Bienvenido a Samsung caYca") 
                    # $location.path('/dashboard') 
                else
                    console.log "SingIn Error" + JSON.stringify(postResponse)
                    logger.logError('Usuario o Contraseña invalida.')
                
                # console.log "Dentro"
                # console.log userDATA
                return        
            return userDATA
        logout: ->
            console.log "Logged Out"
            logger.logSuccess("Hasta luego!")
            # Session.destroy
            $location.path('/accounts/signIn')
            return
])