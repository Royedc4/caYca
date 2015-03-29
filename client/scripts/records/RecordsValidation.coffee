'use strict'

angular.module('app.records.validation', [])

# 1^Store
# Roy: When Enter... AH AH AH!
.directive('ngEnter', () ->
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
.directive('validateSerials', [ () ->
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


# Roy First(old) way
# .directive('validateSerials', [ () ->
#     return {
#         require: 'ngModel'
#         link: (scope, ele, attrs, ngModelCtrl) ->
#             validateEqual = (value) ->
#                 if typeof(value)!='object'
#                     # console.log "Escribiendo=" + value
#                     valid = false

#                     # This way i can make a lot of things too... BUT
#                     # Let's just leave it validating...
#                     # Serial Compressors
#                     for unlabeledSerial in scope.unlabeledSerials
#                         do (unlabeledSerial) ->
#                             if value == unlabeledSerial['SERIAL']
#                                 possibleValidSerial = 
#                                         number: ele['0']['id']
#                                         SERIAL: unlabeledSerial['SERIAL']
#                                 if scope.validSerials.length == 0
#                                     valid=addValidSerial(possibleValidSerial)
#                                 else
#                                     repetido = false
#                                     for readedSerial in scope.validSerials
#                                         do (readedSerial) ->
#                                             if value == readedSerial['SERIAL'] 
#                                                 console.log "Serial: " + value + " Repetido en posicion: " + readedSerial['number']
#                                                 repetido=true

#                                     if !repetido
#                                         valid=addValidSerial(possibleValidSerial)

#                     # console.log ngModelCtrl
#                     ngModelCtrl.$setValidity('inp', valid)
#                     return valid
                    

#             ngModelCtrl.$parsers.push(validateEqual)
#             ngModelCtrl.$formatters.push(validateEqual)

#             addValidSerial = (possibleValidSerial) ->
#                 scope.validSerials.push possibleValidSerial
#                 console.log "Serial: " + possibleValidSerial['SERIAL'] + ", En: " +ele['0']['id'] + ", Valido ;)"
#                 return true                

#             scope.$watch(attrs.validateSerials, (newValue, oldValue) ->
#                 if newValue isnt oldValue # so that watch only fire after change, otherwise watch will fire on load and add invalid style to "confirm" input box
#                     ngModelCtrl.$setViewValue(ngModelCtrl.$ViewValue)
#             )
#     }
# ])


# used for confirm password
# Note: if you modify the "confirm" input box, and then update the target input box to match it, it'll still show invalid style though the values are the same now
# Note2: also remember to use " ng-trim='false' " to disable the trim

# Comment out, use AngularJS built in directive instead.
# unique string, use on unique username, blacklist etc. 

# angularjs already support it, yet you get the picture
# validate number value, jquery free, only number >=x,  <= y are valid, e.g. 1~100, >= 0, <= -1...
# use with AngularJS built in type="number"
# .directive('minvalue', [ ->
#     return {
#         restrict: 'A'
#         require: 'ngModel'
#         link: (scope, ele, attrs, ngModelCtrl) ->
#             minVal = attrs.minvalue

#             validateVal = (value) ->
#                 valid = if value >= 10 then true else false
#                 ngModelCtrl.$setValidity('minVal', valid)

#             scope.$watch(attrs.ngModel, validateVal)

#     }
# ])
# .directive('maxvalue', [ ->
#     return {
#         restrict: 'A'
#         require: 'ngModel'
#         link: (scope, ele, attrs, ngModelCtrl) ->
#             maxVal = attrs.maxvalue

#             validateVal = (value) ->
#                 valid = if value <= maxVal then true else false
#                 ngModelCtrl.$setValidity('maxVal', valid)

#             scope.$watch(attrs.ngModel, validateVal)

#     }
# ])