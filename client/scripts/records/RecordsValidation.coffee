'use strict'

angular.module('app.records.validation', [])

# Roy

# used for confirm password
# Note: if you modify the "confirm" input box, and then update the target input box to match it, it'll still show invalid style though the values are the same now
# Note2: also remember to use " ng-trim='false' " to disable the trim

.directive('validateSerials', [ () ->
    return {
        require: 'ngModel'
        link: (scope, ele, attrs, ngModelCtrl) ->
            validateEqual = (value) ->
                # console.log "Escribiendo=" + value
                i=0
                valid = false
                posicion = null

                for unlabeledSerial in scope.unlabeledSerials
                    do (unlabeledSerial) ->
                        if value == unlabeledSerial['serialID']
                            possibleValidSerial = 
                                    number: ele['0']['id']
                                    serial: unlabeledSerial['serialID']
                                    compressorID: unlabeledSerial['compressorID']
                            if scope.validSerials.length == 0
                                valid=addValidSerial(possibleValidSerial)
                            else
                                repetido = false
                                for readedSerial in scope.validSerials
                                    do (readedSerial) ->
                                        if value == readedSerial['serial'] 
                                            console.log "Serial: " + value + " Repetido en posicion: " + readedSerial['number']
                                            repetido=true

                                if !repetido
                                    valid=addValidSerial(possibleValidSerial)


                # if ( value == scope.unlabeledSerials[i]['serialID'] )
                #     valid = true
                    # console.log "Exito -> " + scope.unlabeledSerials[i]['serialID']
                    # console.log "el primero :) ->" + ele['0']['form']['0'].value
                    # console.log "el segundo :) ->" + $scope.ele['1'].value



                # while i<scope.unlabeledSerials.length
                #     if ( value == scope.unlabeledSerials[i]['serialID'] )
                #         valid = true
                #         console.log "Exito -> " + scope.unlabeledSerials[i]['serialID']
                #         console.log "el primero :) ->" + ele['0']['form']['0'].value
                #         # console.log "el segundo :) ->" + $scope.ele['1'].value
                #     i++

                # valid = ( value is scope.$eval(attrs.validateSerials) )
                # console.log "confirm=" + scope.$eval(attrs.validateSerials)
                ngModelCtrl.$setValidity('equal', valid)
                # console.log "valid=" + valid
                return valid? value : undefined

            ngModelCtrl.$parsers.push(validateEqual)
            ngModelCtrl.$formatters.push(validateEqual)

            addValidSerial = (possibleValidSerial) ->
                # Inserting Info about compressor
                for compressorModel in scope.compressorsInformation
                    do (compressorModel) ->
                        console.log compressorModel + " - "
                        if possibleValidSerial['compressorID'] == compressorModel['compressorID'] 
                            possibleValidSerial['capacity']=compressorModel['capacity']
                            possibleValidSerial['refrigerant']=compressorModel['refrigerant']
                            possibleValidSerial['voltage']=compressorModel['voltage']

                scope.validSerials.push possibleValidSerial
                console.log "Serial: " + possibleValidSerial['serial'] + ", En: " +ele['0']['id'] + ", Valido ;)"
                ele['0']['disabled']=true
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