'use strict';

angular.module('app.labels.ctrls', [])

# Roy
# Controllers for 

.controller('productionCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http) ->
        # Definition of objets

        # Control Data
        $scope.consecVen=[]
        $scope.consecTec=[]
        $scope.consecSer=[]
        # Data 2 Insert
        $scope.data2label=
            serial: []
            tokenTec: []
            tokenVen: []

        #Array of Inputs
        $scope.inputs = []

        #Selected Quantity
        $scope.quantity = 1
        
        # Serials and Label db
        $scope.unlabeledSerials = null
        $scope.unlabeledTokenTecs = null
        $scope.unlabeledTokenVens = null

        # Populating Sequence Arrays
        i = 0
        while i < 100
            if i == 0
                $scope.consecVen[i] = 3
                $scope.consecTec[i] = 2
                $scope.consecSer[i] = 1
            else
                $scope.consecVen[i] = $scope.consecVen[i - 1] + 3
                $scope.consecTec[i] = $scope.consecTec[i - 1] + 3
                $scope.consecSer[i] = $scope.consecSer[i - 1] + 3
            i++

        # Debuging Purposes only
        $scope.roYTesting = ->
            # console.log ">>unlabeledTokenVens>>"
            # console.log $scope.unlabeledTokenVens    
            # console.log ">>unlabeledTokenTecs>>"
            # console.log $scope.unlabeledTokenTecs    
            console.log ">>data2label>>"
            console.log $scope.data2label
            console.log ">>data2insert>>"
            console.log $data2insert
        
        # Form Manipulation
        $scope.revert = ->
            $scope.data2label=
                serial: []
                tokenTec: []
                tokenVen: []
            $scope.loadInputs()
            $scope.serialsForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.serialsForm.$pristine
        $scope.canSubmit = ->
            return $scope.serialsForm.$valid 

        # Creation of Input Dinamically
        $scope.loadInputs = ->
            # 4not Adding more
            $scope.inputs = []
            i=0
            while i<($scope.quantity)
                # console.log i+"/"+$scope.quantity
                j=i+1
                $scope.inputs.push({ placeholder: "Serial Compresor # " + j})
                $scope.inputs.push({ placeholder: "S# "+j+" TOKEN Tecnico" })
                $scope.inputs.push({ placeholder: "S# "+j+" TOKEN Vendedor" })
                i++
            logger.log("Se ha preparado el formulario. Proceda a leer los seriales con el lector de codigo de barras.") 

        # Roy: Loading DATA FORM DB
        # Loading unlabeled Serials
        getUnlabeledSerials = ->
            $filters=
                companyID: '20'
            $http({ url: "http://cayca:8888/server/ajax/Serials/listUnlabeledFiltered.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.unlabeledSerials=postResponse
            return
        getUnlabeledSerials()

        # Loading unlabeled Tokens Tec
        getunlabeledTokenTec = ->
            $filters=
                country: 'CO'
                type: 'T'
            $http({ url: "http://cayca:8888/server/ajax/Tokens/listUnlabeledFiltered.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.unlabeledTokenTecs=postResponse
            return
        getunlabeledTokenTec()

        # Loading unlabeled Tokens Ven
        getunlabeledTokenVens = ->
            $filters=
                country: 'CO'
                type: 'V'
            $http({ url: "http://cayca:8888/server/ajax/Tokens/listUnlabeledFiltered.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.unlabeledTokenVens=postResponse
            return
        getunlabeledTokenVens()

        # Preparing DATA 2 Insert
        $data2insert=
            token:[]
            serial:[]
        # Saving Labels 4 Prints at bartender
        preparingData = ->
            $data2insert=
            token:[]
            serial:[]
            for iteration in [0...$scope.data2label['serial'].length] by 1
                $data2insert['serial'].push($scope.data2label['serial'][iteration])
                $data2insert['token'].push($scope.data2label['tokenTec'][iteration])
                $data2insert['serial'].push($scope.data2label['serial'][iteration])
                $data2insert['token'].push($scope.data2label['tokenVen'][iteration])

        # Saving Labels 4 Prints at bartender
        $scope.requestLabels = ->                 
            preparingData()
            $http({ url: "http://cayca:8888/server/ajax/labeledSerials/add.php", method: "POST", data: JSON.stringify($data2insert) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (parseInt(postResponse)>=1)
                        logger.logSuccess "Se han registrado exitosamente las " +$scope.data2label['serial'].length + " Etiqueta(s)."
                    if (postResponse.indexOf("PRIMARY")!=-1)
                        logger.logWarning "Ya solicitaste la(s) " +$scope.data2label['serial'].length + " Etiquetas. Si ya se imprimieron debes confirmar para finalizar."
                console.log postResponse
        
        $scope.confirmLabels = ->
            preparingData()
            $http({ url: "http://cayca:8888/server/ajax/labeledSerials/updateDate.php", method: "POST", data: JSON.stringify($data2insert) })
            .success (postResponse) ->
                if (typeof postResponse) == "string"
                    if (postResponse=="1")
                        logger.logSuccess "Ha concluido el etiquetado de " +$scope.data2label['serial'].length + " compresor(es)."
                        $scope.revert()
                    if (postResponse.indexOf("request")!=-1)
                        logger.logError "Debes solicitar las etiquetas antes de confirmar sus impresiones."
                    if (postResponse.indexOf("Labeled")!=-1)
                        logger.logWarning "Ya cumlminaste la impresion de la(s) " +$scope.data2label['serial'].length + " Etiqueta(s)."
                        $scope.revert()
                console.log postResponse

])

