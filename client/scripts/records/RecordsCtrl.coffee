'use strict';

angular.module('app.records.ctrls', [])

# Roy
# Controllers for MakeInvoice

.controller('makeLabelsCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http) ->

        # Roy : Form Part

        # $scope.user = 
        #     name: ''
        #     email: ''
        #     password: ''
        #     confirmPassword: ''
        #     age: ''

        # $scope.showInfoOnSubmit = false

        # original = angular.copy($scope.user)

        $scope.revert = ->
            # $scope.user = angular.copy(original)
            # $scope.form_signup.$setPristine()
            # $scope.form_signup.confirmPassword.$setPristine()
            # console.log $scope.validSerials
            $scope.validSerials = []
            # console.log $scope.validSerials
            # $scope.unlabeledSerials = []
            $scope.inputs
            $scope.loadInputs()
            $scope.serialsForm.$setPristine()




        $scope.canRevert = ->
            return !$scope.serialsForm.$pristine

        $scope.canSubmit = ->
            return $scope.serialsForm.$valid 

        # $scope.submitForm = ->
        #      $scope.showInfoOnSubmit = true
        #      $scope.revert()    

        # Roy: Serials Part
        #Array of Inputs
        $scope.inputs = []

        #Selected Quantity
        $scope.quantity = 1
        
        # Serials without label
        $scope.unlabeledSerials = null
        # Information about compressors
        $scope.compressorsInformation = null
        # Serials valid to insert in db
        $scope.validSerials = []

        # $("barcode").JsBarcode("RoyCalderon");


        $scope.loadInputs = ->
            # 4not Adding more
            $scope.inputs = []

            # num = $scope.inputs.length          
            i=0
            console.log $scope.quantity
            while i<($scope.quantity)
                # console.log i+"/"+$scope.quantity
                j=i+1
                $scope.inputs.push({ placeholder: "Serial Compresor #" + j })
                i++
            logger.log("Se ha preparado el formulario. Proceda a leer los seriales con el lector de codigo de barras.") 

        #Load unlabeled Serials
        getUnlabeledSerials = ->
            $http.post("http://cayca:8888/server/ajax/Serials/getUnlabeled.php?countryID=CO").success (data) ->
                $scope.unlabeledSerials = data
                return
            return
        getUnlabeledSerials()
        
        #Load Compressors Information
        getCompressorsInformation = ->
            $http.post("http://cayca:8888/server/ajax/Compressors/getCompressor.php").success (data) ->
                $scope.compressorsInformation = data
                return
            return
        getCompressorsInformation()

        $scope.printSecurityLabel = ->
            # printContents = "<h3> SAMSUNG "+ $scope.validSerials[0]['capacity'] + " " + $scope.validSerials[0]['refrigerant'] + "</h3>"
            # printContents = '<div class="col-xs-6">
            #         <h6>SAMSUNG MK183D-L2UB<br>
            #             <img id="barcode1"/><br>
            #             R-134a 115-127V 1/3
            #         </h6>
            #         <script>
            #             $("#barcode1").JsBarcode("4158C3BF800855", {width:1,height:30});
            #         </script>
            #     </div>'
            printContents = document.getElementById('ROOOOY').innerHTML;
            originalContents = document.body.innerHTML;        
            popupWin = window.open();
            popupWin.document.open()
            popupWin.document.write('<html><head></head><body onload="window.print()">' + printContents + '</html>');
            popupWin.document.close();


])






# Roy
# Controllers for MakeInvoice

.controller('newLabelsCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http) ->
        $scope.dataInserted=[]

        $scope.roYTesting = ->
            console.log $scope.dataInserted
            console.log $scope.unlabeledSerials
            console.log $scope.validSerials
        
        $scope.revert = ->
            $scope.validSerials = []
            $scope.inputs
            $scope.loadInputs()
            $scope.serialsForm.$setPristine()

        $scope.canRevert = ->
            return !$scope.serialsForm.$pristine

        $scope.canSubmit = ->
            return $scope.serialsForm.$valid 

        #Array of Inputs
        $scope.inputs = []

        #Selected Quantity
        $scope.quantity = 1
        
        # Serials without label
        $scope.unlabeledSerials = null
        $scope.unusedtokens = null
        $scope.labeledData = null
        # Serials valid to insert in db
        $scope.validSerials = []

        $scope.loadInputs = ->
            # 4not Adding more
            $scope.inputs = []

            # num = $scope.inputs.length          
            i=0
            console.log $scope.quantity
            while i<($scope.quantity)
                # console.log i+"/"+$scope.quantity
                j=i+1
                $scope.inputs.push({ placeholder: "Serial Compresor # " + j})
                $scope.inputs.push({ placeholder: "S# "+j+" TOKEN Tecnico" })
                $scope.inputs.push({ placeholder: "S# "+j+" TOKEN Vendedor" })
                i++
            logger.log("Se ha preparado el formulario. Proceda a leer los seriales con el lector de codigo de barras.") 

        #Load unlabeled Serials
        getUnlabeledSerials = ->
            $http.post("http://cayca:8888/server/ajax/Serials/getUnlabeled.php?companyID=20").success (data) ->
                $scope.unlabeledSerials = data
                return
            return
        getUnlabeledSerials()

        #Load unused Tokens
        getUnusedTokens = ->
            $http.post("http://cayca:8888/server/ajax/Serials/getUnlabeled.php?companyID=20").success (data) ->
                $scope.unusedtokens = data
                return
            return
        getUnusedTokens()

        #Load Labeled DATA
        getLabeledData = ->
            $http.post("http://cayca:8888/server/ajax/Serials/getUnlabeled.php?companyID=20").success (data) ->
                $scope.labeledData = data
                return
            return
        getLabeledData()
       

])

