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
                    scope.data2label['serial'].push(element.context.value.toUpperCase())
                if scope.consecTec.indexOf(parseInt(element['0'].name.substr(5,3))) != -1
                    scope.data2label['tokenTec'].push(element.context.value.toUpperCase())
                if scope.consecVen.indexOf(parseInt(element['0'].name.substr(5,3))) != -1
                    scope.data2label['tokenVen'].push(element.context.value.toUpperCase())

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
                    alreadyLabeled = false

                    # Validating the write of SERIALS
                    if scope.consecSer.indexOf(parseInt(ele['0'].name.substr(5,3))) != -1
                        #Looping at Unlabeled
                        for unlabeledSerial in scope.unlabeledSerials
                            do (unlabeledSerial) ->
                                # It's unlabeled
                                if (unlabeledSerial['SERIAL']==value.toUpperCase())
                                    #Looping at Labeled
                                    for labeledSerial in scope.labeledSerials
                                        do (labeledSerial) ->
                                            # It's Labeled
                                            if (labeledSerial['SERIAL']==value.toUpperCase())
                                                alreadyLabeled = true
                                    if !alreadyLabeled
                                        if scope.data2label['serial'].length>0
                                            if scope.data2label['serial'].indexOf(value.toUpperCase()) ==-1
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
                                if (unlabeledTokenTec['token']==value.toUpperCase())
                                    if scope.data2label['tokenTec'].length>0
                                        if scope.data2label['tokenTec'].indexOf(value.toUpperCase()) ==-1
                                            valid=true
                                    else
                                        valid=true

                    # Validating the write of VEN Tokens
                    if scope.consecVen.indexOf(parseInt(ele['0'].name.substr(5,3))) != -1
                        for unlabeledTokenVen in scope.unlabeledTokenVens
                            do (unlabeledTokenVen) ->
                                if (unlabeledTokenVen['token']==value.toUpperCase())
                                    if scope.data2label['tokenVen'].length>0
                                        if scope.data2label['tokenVen'].indexOf(value.toUpperCase()) ==-1
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