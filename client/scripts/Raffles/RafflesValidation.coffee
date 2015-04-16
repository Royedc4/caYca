'use strict'

angular.module('app.raffles.validation', [])

# Roy: When Finish writting maxLenght
.directive('ngRaffleTokensTabs',  ->
	return { 
		link: (scope, element, attrs) ->
			element.bind('keypress', (event) ->
				# this.maxLenght doesn't work because of ui-tools so it's static.
				tokenLiveLength=this.value.replace( /_/g,"").replace(/-/g,"").length+1
				if (tokenLiveLength==5 or tokenLiveLength==9)
					this.value=this.value.concat("-")
				if (tokenLiveLength>=12)
					if parseInt(this.name.substr(5,3))>=scope.quantity
						document.getElementById('registerToken4rafffleButton').focus()
						console.log "Paso a Register"
					else
						# Funciona siempre y cuando no se use ui-tools
						console.log "paso a otro input"
						document.getElementById('input'+(parseInt(this.name.substr(5,3))+1).toString()).focus()
						# $('#'+attrs.ngRaffleTokensTabs)['0'].focus()
						# element.context.nextSibling.parentElement.nextElementSibling.firstElementChild.focus()
						# $('#'+attrs.ngRaffleTokensTabs).focus()
						# console.log element2tab.focus()
						# this['disabled']=true

					# Esperar porque sino no guarda el ultimo digito... xD
					setTimeout ( ->
						scope.data2insert['token'].push(angular.uppercase element.context.value)
					), 1000
					
			)
	}
)