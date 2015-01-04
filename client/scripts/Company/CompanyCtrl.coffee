'use strict'

angular.module('app.company.ctrls', [])

.controller('NewCompanyCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http ) ->
        console.log "@NewCompanyCtrl 4: Mayor->GerenteComercial :)"
        # ng-model 4 company
        $scope.company = 
            businessName: ''
            nit: ''
            email: ''
            address: ''
            phone: ''
            citySelected: ''

        # Load cities
        getCities = ->
            $http.post("http://cayca:8888/server/ajax/Tables/getCity.php").success (data) ->
                $scope.cities = data
                return
            return
        getCities()

        $scope.showInfoOnSubmit = false

        original = angular.copy($scope.company)

        $scope.revert = ->
            $scope.company = angular.copy(original)
            $scope.form_NewCompany.$setPristine()

        $scope.canRevert = ->
            return !angular.equals($scope.company, original) || !$scope.form_NewCompany.$pristine

        $scope.canSubmit = ->
            return $scope.form_NewCompany.$valid && !angular.equals($scope.company, original)

        $scope.submitForm = ->
             $scope.showInfoOnSubmit = true
             $scope.revert()     

        # Create New Company
        $scope.createNewCompany = ->
            # Data Object
            $scope.data = 
                businessName: $scope.company.businessName
                nit: $scope.company.nit
                email: $scope.company.email
                address: $scope.company.address
                phone: $scope.company.phone
                geoID: $scope.company.citySelected.geoID
            
            $http.defaults.headers.post["Content-Type"] = "application/json"            
                        
            $http({ url: "http://cayca:8888/server/ajax/Companies/addCompany.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                if postResponse.indexOf("entry")
                    console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logError "La empresa ya estaba en la base de datos."
                else
                    console.log "Roy: " + JSON.stringify(postResponse)
                    logger.logSuccess "Se ha creado exitosamente la empresa."
                    $scope.revert()
                # console.log "success postResponse: " + (postResponse)
                # console.log "Roy: " + JSON.stringify(postResponse)
                # logger.logSuccess('Se ha creado exitosamente la empresa.')
                # # Probar el error o else para mensajes de error...
                # $scope.revert()
            .error (postResponse) ->
                console.log "error"
            return
        return
        
])

