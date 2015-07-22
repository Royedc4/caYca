'use strict';

angular.module('app.sales.directives', [])

# Validate ClientName
.directive('validateClient', [ () ->
	return {
		require: 'ngModel'
		link: (scope, ele, attrs, ngModelCtrl) ->
			validateEqual = (value) ->
				if typeof(value)!='object' and typeof(scope.retailers)!='undefined'
					valid = false
                    #Looping at Clients
					for retailer in scope.retailers
						do (retailer) ->
							if (retailer['businessName'].toUpperCase()==value.toUpperCase())
								valid=true
								scope.buyer_companyID=retailer['companyID']
                # Validating input
				ngModelCtrl.$setValidity('buyer_businessName', valid)
				return value
                    
			ngModelCtrl.$parsers.push(validateEqual)
			ngModelCtrl.$formatters.push(validateEqual)
	}
])

# Validate Invoice Number
.directive('validateInvoice', [ () ->
	return {
		require: 'ngModel'
		link: (scope, ele, attrs, ngModelCtrl) ->
			validateEqual = (value) ->
				if typeof(value)!='object'
					valid = true
                    #Looping at BillsNumbers
					for billNumber in scope.billsNumbers
						do (billNumber) ->
							if (billNumber['number'].toUpperCase()==value.toUpperCase())
								valid=false
                # Validating input
				ngModelCtrl.$setValidity('number', valid)
				return value
                    
			ngModelCtrl.$parsers.push(validateEqual)
			ngModelCtrl.$formatters.push(validateEqual)
	}
])

# Roy: When Enter... Save data and pass
.directive('ngEnterSerials', () ->
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
				scope.serials2sell.push(element.context.value.toUpperCase())
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
					valid = false
                    #Looping at Unlabeled
					for unsoldSerial in scope.unsoldSerials
						do (unsoldSerial) ->
                            # It's unlabeled
							if (unsoldSerial['SERIAL']==value.toUpperCase())
								valid=true
								if scope.serials2sell.length>0
								    if scope.serials2sell.indexOf(value.toUpperCase()) !=-1
								        # Repeated hence invalid
								        valid=false
							if valid and (unsoldSerial['SERIAL']==value.toUpperCase())
								scope.orderedSerials.push(unsoldSerial)
								# scope.orderedSerials[unsoldSerial['compressorID']].push=unsoldSerial['SERIAL']
                    
                # Validating input
				ngModelCtrl.$setValidity('inp', valid)
				return valid
                    
			ngModelCtrl.$parsers.push(validateEqual)
			ngModelCtrl.$formatters.push(validateEqual)
	}
])