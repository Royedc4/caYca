'use strict'
angular.module('app.sales.ctrls', [])
.controller('salesCtrl', [
    'REST_API','$scope', 'logger', '$http', '$window'
    (REST_API,$scope, logger, $http, $window) ->
        console.log 'salesCtrl'
        # Preparing DATA 2 Insert
        $scope.orderedSerials=[]
        $scope.serialString=' '
        $scope.serialString2=' '
        $scope.billsNumbers=''
        $scope.serials2sell= []
        $scope.seller_userID=''
        $scope.buyer_businessName=''
        $scope.buyer_companyID=''
        $scope.number=''
        $scope.date=new Date()
        # Filtering avaiables dates
        $scope.dateMax=(moment().add(1, 'days')).format('L')
        $scope.dateMin=(moment().subtract(1, 'days')).format('L')
        
        #Array of Inputs
        $scope.inputs = []

        #Selected Quantity
        $scope.quantity = ''

        # Serials and Label db
        $scope.unsoldSerials = []

        # Debuging Purposes only
        $scope.roYTesting = -> 
            prepareData() 
            console.log $scope.billsNumbers.length + ">>billNumbers>>"
            console.log $scope.billsNumbers
            console.log $scope.retailers.length + ">>retailers CO>>"
            console.log $scope.retailers
            console.log $scope.unsoldSerials.length+">>unsoldSerials>>"
            console.log $scope.unsoldSerials
            console.log ">>scope.data2insert>>"
            console.log $scope.data2insert
            console.log "Primer Serial:"+$scope.serialString
            console.log "Otro Serial:"+$scope.serialString2

        
        # Form Manipulation
        $scope.revert = ->
            $scope.serialString=' '
            $scope.serialString2=' '
            $scope.orderedSerials= []
            $scope.seller_userID = $scope.currentUser.userID
            $scope.buyer_businessName = ''
            $scope.buyer_companyID=''
            $scope.number = ''
            $scope.serials2sell = []
            $scope.date= ''
            $scope.loadInputs()
            $scope.invoiceForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.invoiceForm.$pristine
        $scope.canSubmit = ->
            return $scope.invoiceForm.$valid 

        # Creation of Input Dinamically
        $scope.loadInputs = ->
            # order this
            $scope.orderedSerials=[]
            getUnsoldSerials()
            getBillsNumbers()
            # 4not Adding more
            $scope.inputs = []
            i=1
            while i<($scope.quantity+1)
                if i==1
                    setTimeout ->
                        document.getElementById('input1').focus()
                    , 100
                # console.log i+"/"+$scope.quantity
                $scope.inputs.push({ placeholder: "Compresor #" + i})
                i++
            logger.log("Se ha preparado el formulario. Proceda a leer los seriales con el lector de codigo de barras.") 

        prepareData = ->
            for iteration in [0..$scope.serials2sell.length-1-(Math.floor($scope.serials2sell.length/21))] by 1
                $scope.serialString=$scope.serialString+$scope.serials2sell[iteration]+" "
            if $scope.serials2sell.length>21
                for iteration in [$scope.serials2sell.length-(Math.floor($scope.serials2sell.length/21))..$scope.serials2sell.length-1] by 1
                    $scope.serialString2=$scope.serialString2+$scope.serials2sell[iteration]+" "

            $scope.data2insert=
                seller_userID : $scope.currentUser.userID
                number : $scope.number
                buyer_companyID: $scope.buyer_companyID
                date: moment($scope.date).format('MM-DD-YYYY')
                serials: $scope.serials2sell
                description: $scope.currentUser.company.businessName+" >> "+$scope.buyer_businessName
        
        # Roy: Loading DATA FROM DB

        #Load companies
        getRetailerCompanies = ->
            $filters=
                isRetailer: true
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/Company/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.retailers =postResponse
            return
        getRetailerCompanies()

        # Loading Unsold 4 company
        getUnsoldSerials = ->
            $filters=
                companyID: $scope.currentUser.companyID
            $http({ url: REST_API.hostname+"/server/ajax/Serials/listUnSoldFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.unsoldSerials=postResponse
        getUnsoldSerials()

        # Loading bills Numbers
        getBillsNumbers = ->
            $filters=
                seller_userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/Bill/listBySeller.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.billsNumbers=postResponse
            return
        getBillsNumbers()

        $scope.saveBill = ->
            prepareData()
            $http({ url: REST_API.hostname+"/server/ajax/Bill/new.php", method: "POST", data: JSON.stringify($scope.data2insert) })
            .success (postResponse) ->
                console.log postResponse
                console.log typeof(postResponse)
                if (typeof postResponse).toString() == "object"
                    console.log "entre a postResponse"
                    if (postResponse['zGlobalResult']==true)
                        console.log "entre zGlobalResult"
                        logger.logSuccess "Ha concluido el registro de " +$scope.data2insert['serials'].length + " compresor(es) en la factura "+$scope.data2insert['number']
                        if (postResponse['errorsArray'].indexOf("Duplicate")!=-1)
                            console.log "entre errorsArray"
                            logger.logError "Se ha generado un error interno."
        
        $scope.printInvoice = ->        
            printContents = document.getElementById('invoice').innerHTML;
            originalContents = document.body.innerHTML;        
            popupWin = window.open();
            popupWin.document.open()
            popupWin.document.write('<html><head><link rel="stylesheet" type="text/css" href="styles/main.css" /></head><body onload="window.print()">' + printContents + '</html>');
            popupWin.document.close();          
])

.controller('listSalesCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        # Definition of objets
        $scope.sales = []
        $scope.searchKeywords = ''
        $scope.filteredSales = []
        $scope.row = ''

        # xD
        console.log 'listSalesCtrl'

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageSales = $scope.filteredSales.slice(start, end)

        # on page change: change numPerPage, filtering string
        $scope.onFilterChange = ->
            $scope.select(1)
            $scope.currentPage = 1
            $scope.row = ''

        $scope.onNumPerPageChange = ->
            $scope.select(1)
            $scope.currentPage = 1

        $scope.onOrderChange = ->
            $scope.select(1)
            $scope.currentPage = 1            

        $scope.search = ->
            $scope.filteredSales = $filter('filter')($scope.sales, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredSales = $filter('orderBy')($scope.sales, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageSales = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        #Load companies
        getInvoices = ->
            $filters=
                companyID: $scope.currentUser.company.companyID
            $http({ url: REST_API.hostname+"/server/ajax/company/getMA4company.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    # console.log postResponse['0']['@ma4company']
                    $filters=
                        seller_userID: postResponse['0']['@ma4company']
                    $http({ url: REST_API.hostname+"/server/ajax/Bill/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                        .success (postResponse) ->
                            # console.log postResponse                    
                            $scope.sales =postResponse
                        # Only way to make react on filter to show items on table
                        setTimeout ->
                            $('#searchKeywords').focus()
                            angular.element('#orderIDsalesUP').trigger('click')
                            if $scope.filteredSales.length==0
                                logger.logError "No se encontraron ventas registradas en su empresa."
                            else
                                logger.logSuccess "Tiene "+$scope.sales.length+" ventas registradas."
                        , 250
                    return
        getInvoices()


        #Load companies
        # getInvoices = ->
        #     $filters=
        #         seller_userID: $scope.currentUser.userID
        #     $http({ url: REST_API.hostname+"/server/ajax/Bill/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
        #         .success (postResponse) ->
        #             console.log postResponse
        #             $scope.sales =postResponse
        #         # Only way to make react on filter to show items on table
        #         setTimeout ->
        #             $('#searchKeywords').focus()
        #             angular.element('#orderIDsalesUP').trigger('click')
        #             if $scope.filteredSales.length==0
        #                 logger.logError "No se encontraron ventas registradas en su empresa."
        #             else
        #                 logger.logSuccess "Tiene "+$scope.sales.length+" ventas registradas."
        #         , 250
        #     return
        # getInvoices()
])


.controller('eraseInvoiceCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout', '$location'
    (REST_API,$scope, logger, $http, $filter, $timeout, $location) ->
        
        getInvoices = ->
            $filters=
                seller_userID: $scope.currentUser.userID
            $http({ url: REST_API.hostname+"/server/ajax/Bill/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.sales =postResponse
                    # console.log $scope.sales
        getInvoices()
        
        $scope.eraseInvoice = ->
            invoiceData=null
            for i in $scope.sales
                if [i][0].number==$scope.invoiceNumber
                    invoiceData=[i][0]
            if invoiceData
                swal {
                    title: 'Seguro que quiere eliminar la factura:'
                    text: '#: ' + invoiceData.number + '\nFecha: ' + invoiceData.date + '\nEmpresa: ' + invoiceData.businessName + '\n\nEste proceso es totalmente irreversible!'
                    type: 'error'
                    showCancelButton: true
                    closeOnConfirm: false
                    showLoaderOnConfirm: true
                }, ->
                    $filters=
                        eraser_userID: $scope.currentUser.userID
                        eraser_fullName: $scope.currentUser.fullName
                        eraser_businessName: $scope.currentUser.company.businessName
                        billNumber: invoiceData.number
                    $http({ url: REST_API.hostname+"/server/ajax/Bill/erase.php", method: "POST", data: JSON.stringify($filters) })
                        .success (postResponse) ->
                            # console.log postResponse
                            $location.path('/sales/list') 
                            setTimeout (->
                                swal 'Factura Eliminada!', 'Se ha eliminado exitosamente la factura: #' + invoiceData.number, 'success'
                            ), 1500
            else
                swal 'Error', 'La factura: #'+$scope.invoiceNumber+' no existe.', 'error'
])
