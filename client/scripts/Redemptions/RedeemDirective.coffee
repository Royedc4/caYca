'use strict';

angular.module('app.redemptions.directives', [])

# 1^ Show validation
# Validate Serials and Tokens
.directive('someTokens', [ () ->
    return {
        require: 'ngModel'
        link: (scope, ele, attrs, ngModelCtrl) ->
            someToken = (value) ->                    
            ngModelCtrl.$parsers.push(someToken)
            ngModelCtrl.$formatters.push(someToken)
    }
])