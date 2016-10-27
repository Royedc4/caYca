'use strict'
angular.module('app.landing.ctrls', [])

.controller('ModalTerminosCtrl', [
    '$scope', '$modal', '$log'
    ($scope, $modal, $log) ->
        $scope.open = ->
            modalInstance = $modal.open(
                templateUrl: "terminosModal.html"
                controller: 'terminosModalInstanceCtrl'
            )
            modalInstance.result.then ((result) ->
                $scope.messageResult = result
            )
])

.controller('terminosModalInstanceCtrl', [
    '$scope', '$modalInstance', '$log'
    ($scope, $modalInstance, $log) ->
        $scope.ok = ->
            $modalInstance.close "ok"
        $scope.cancel = ->
            $modalInstance.dismiss "cancel"
])

.controller('landingCtrl', [
    'REST_API','$scope', 'logger', '$http', '$window', '$document', '$animate'
    (REST_API,$scope, logger, $http, $window, $document, $animate) ->
        console.log 'landingCtrl'

        # Checking compatibility browser and telling
        $scope.supportsGeo = $window.navigator;
        $window.navigator.geolocation.getCurrentPosition ((position) ->
            $scope.$apply ->
                $scope.userGPS=position.coords
            # logger.logSuccess "Mira el mapa!"
        ), (error) ->
            logger.logError "No podemos obtener su ubicación! Intenta desde otro dispositivo y acepta la solicitud de GPS."
        # Stores 4 map!
        $scope.stores = 
        [
            {
                name: 'REFRONCA'
                ID: 'ChIJb5YwAHhFZo4Rv7TDoZTSz0Q'
            }
            {
                name: 'TRS'
                ID: 'ChIJJ2wON0soRI4RvvQuCFETieQ'
            }
            {
                name: 'ELNEVADO'
                ID: 'ChIJL4W7l3AVaI4RPlEb3GgEuL8'
            }
            {
                name: 'REFRIANDES'
                ID: 'ChIJy7GY_iycP44RPXS9W_Jn8sM'
            }
        ]
        $scope.tiendas = []
        map = new (google.maps.Map)(document.getElementById('map'))
        service = new (google.maps.places.PlacesService)(map)
        for store in $scope.stores
            service.getDetails { placeId: store.ID }, (place, status) ->
                if status == google.maps.places.PlacesServiceStatus.OK
                    $scope.tiendas.push place
                    if $scope.storeSelected==undefined
                        $scope.storeSelected=$scope.tiendas[0]

        # Getting rotCompressors
        rotCompressors = ->
            $http({ url: REST_API.hostname+"/server/ajax/Compressors/rotInfo.php", method: "POST"})
            .success (postResponse) ->
                $scope.rotCompressors=postResponse
        rotCompressors()

        # Getting recCompressors
        recCompressors = ->
            $http({ url: REST_API.hostname+"/server/ajax/Compressors/recInfo.php", method: "POST"})
            .success (postResponse) ->
                $scope.recCompressors=postResponse
        recCompressors()        
])

.controller('landingRetailers', [
    'MAPS_API', 'REST_API', '$filter', '$scope', 'logger', '$http', '$window' , '$location', '$routeParams'
    (MAPS_API, REST_API, $filter, $scope, logger, $http, $window, $location, $routeParams) ->   
        getRetailerCompanies = ->
            $filters=
                isRetailer: true
                country: 'CO'
            $http({ url: REST_API.hostname+"/server/ajax/Company/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.retailers =postResponse
                    getRetailerStates()
        getRetailerCompanies()

        getRetailerStates = ->
            $scope.retailerStates=[]
            $scope.retailers.forEach (retailerDB) ->
                if $scope.retailerStates.length==0
                    $scope.retailerStates.push(retailerDB.state)
                else
                    if $scope.retailerStates.indexOf(retailerDB.state) ==-1
                        $scope.retailerStates.push(retailerDB.state)
                $scope.stateSelected = $scope.retailerStates[0]
                $scope.updateFilter()
        $scope.filteredRetailers = []
        $scope.row = ''

        $scope.updateFilter = ->
            $scope.filteredRetailers = $filter('filter')($scope.retailers, $scope.stateSelected)
        ])