'use strict'

angular.module('app.records.validation', [])

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
                # xD
                scope.dataInserted.push({input:element.context.value,value:element.context.name})
        )
)


# Roy
# used for confirm password
# Note: if you modify the "confirm" input box, and then update the target input box to match it, it'll still show invalid style though the values are the same now
# Note2: also remember to use " ng-trim='false' " to disable the trim

.directive('validateSerials', [ () ->
    return {
        require: 'ngModel'
        link: (scope, ele, attrs, ngModelCtrl) ->
            validateEqual = (value) ->
                console.log "Escribiendo=" + value
                i=0
                valid = false
                posicion = null

                for unlabeledSerial in scope.unlabeledSerials
                    do (unlabeledSerial) ->
                        if value == unlabeledSerial['SERIAL']
                            possibleValidSerial = 
                                    number: ele['0']['id']
                                    SERIAL: unlabeledSerial['SERIAL']
                            if scope.validSerials.length == 0
                                valid=addValidSerial(possibleValidSerial)
                            else
                                repetido = false
                                for readedSerial in scope.validSerials
                                    do (readedSerial) ->
                                        if value == readedSerial['SERIAL'] 
                                            console.log "Serial: " + value + " Repetido en posicion: " + readedSerial['number']
                                            repetido=true

                                if !repetido
                                    valid=addValidSerial(possibleValidSerial)

                console.log "isValid?="+valid
                ngModelCtrl.$setValidity('equal', valid)
                ngModelCtrl.$setValidity(ele['0']['id'], valid)
                ngModelCtrl.$setValidity('validateEqual', valid)
                ngModelCtrl.$setValidity('validate-equals', valid)
                ngModelCtrl.$setValidity('data-validate-equals', valid)
                ngModelCtrl.$setValidity('data-validate-serials', valid)
                return valid? value : undefined

            ngModelCtrl.$parsers.push(validateEqual)
            ngModelCtrl.$formatters.push(validateEqual)

            addValidSerial = (possibleValidSerial) ->
                scope.validSerials.push possibleValidSerial
                console.log "Serial: " + possibleValidSerial['SERIAL'] + ", En: " +ele['0']['id'] + ", Valido ;)"
                # ele['0']['disabled']=true
                return true                

            scope.$watch(attrs.validateSerials, (newValue, oldValue) ->
                # console.log "new=" + newValue
                # console.log "old=" + oldValue
                if newValue isnt oldValue # so that watch only fire after change, otherwise watch will fire on load and add invalid style to "confirm" input box
                    ngModelCtrl.$setViewValue(ngModelCtrl.$ViewValue)
            )
    }
])


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