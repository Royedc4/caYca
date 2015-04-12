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

# Roy: When Enter... AH AH AH!
.directive('ngEnterTokens', () ->
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
        )
)
