'use strict'

angular.module('app.labels.validation', [])

# 1^Store
# Roy: When Enter... AH AH AH!
.directive('ngEnterLabels', () ->
    return (scope, element, attrs) ->
        element.bind("keydown keypress", (event) ->
            # Enter
            if(event.which == 13)
                scope.$apply( ()->
                    scope.$eval(attrs.ngEnter)
                )
                # No Enter(ing)
                event.preventDefault()
                # IF !last -> Focus Next 
                if element.context.nextSibling.parentElement.nextElementSibling
                    element.context.nextSibling.parentElement.nextElementSibling.firstElementChild.focus()

                # Storing values on differents Arrays depending on inputLocation
                if scope.consecSer.indexOf(parseInt(element['0'].name.substr(5,3))) != -1
                    scope.data2label['serial'].push(element.context.value)
                if scope.consecTec.indexOf(parseInt(element['0'].name.substr(5,3))) != -1
                    scope.data2label['tokenTec'].push(element.context.value)
                if scope.consecVen.indexOf(parseInt(element['0'].name.substr(5,3))) != -1
                    scope.data2label['tokenVen'].push(element.context.value)

                element['0']['disabled']=true
        )
)


# 1^ Show validation
# Validate Serials and Tokens
.directive('validateLabels', [ () ->
    return {
        require: 'ngModel'
        link: (scope, ele, attrs, ngModelCtrl) ->
            validateEqual = (value) ->
                if typeof(value)!='object'
                    # console.log "Escribiendo=" + value
                    valid = false

                    # Validating the write of SERIALS
                    if scope.consecSer.indexOf(parseInt(ele['0'].name.substr(5,3))) != -1
                        for unlabeledSerial in scope.unlabeledSerials
                            do (unlabeledSerial) ->
                                if (unlabeledSerial['SERIAL']==value)
                                    if scope.data2label['serial'].length>0
                                        if scope.data2label['serial'].indexOf(value) ==-1
                                            # Not repeated
                                            valid=true
                                    else
                                        # First Item 
                                        valid=true
                                    # console.log "Unlabeled:"+unlabeledSerial['SERIAL']
                                    # console.log "Se guarda"
                        # console.log "ESCRIBIENDO 1 serial"

                    # Validating the write of TEC Tokens
                    if scope.consecTec.indexOf(parseInt(ele['0'].name.substr(5,3))) != -1
                        for unlabeledTokenTec in scope.unlabeledTokenTecs
                            do (unlabeledTokenTec) ->
                                if (unlabeledTokenTec['token']==value)
                                    if scope.data2label['tokenTec'].length>0
                                        if scope.data2label['tokenTec'].indexOf(value) ==-1
                                            valid=true
                                    else
                                        valid=true

                    # Validating the write of VEN Tokens
                    if scope.consecVen.indexOf(parseInt(ele['0'].name.substr(5,3))) != -1
                        for unlabeledTokenVen in scope.unlabeledTokenVens
                            do (unlabeledTokenVen) ->
                                if (unlabeledTokenVen['token']==value)
                                    if scope.data2label['tokenVen'].length>0
                                        if scope.data2label['tokenVen'].indexOf(value) ==-1
                                            valid=true
                                    else
                                        valid=true
                    
                    # Validating input
                    ngModelCtrl.$setValidity('inp', valid)
                    return valid
                    
            ngModelCtrl.$parsers.push(validateEqual)
            ngModelCtrl.$formatters.push(validateEqual)
    }
])