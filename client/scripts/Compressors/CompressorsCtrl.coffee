'use strict'

angular.module('app.compressors', [])

.controller('keysCtrl', [
    'REST_API','$scope', 'logger', '$http'
    (REST_API,$scope, logger, $http) ->

        $scope.countrySelected=''


        #Load Countries
        getCountries = ->
            $http.post(REST_API.hostname+"/server/ajax/Country/list.php").success (data) ->
                $scope.countries = data
                return
            return
        getCountries()

        $scope.Keys = {TEC:[] ,DV: []}
        $KeysAtDB = {TEC:[] ,DV: []}

        #Loading Keys
        $scope.getDBKeys = ->
            console.log "getDBKeys"
            $data4post = 
                country: $scope.countrySelected.country
                type: 'T'
            $http({url:REST_API.hostname+"/server/ajax/Tokens/listFiltered.php", method: "POST", data: JSON.stringify($data4post) })
            .success (dataTEC) ->
                iterator=0
                while (iterator<dataTEC.length)
                   $KeysAtDB["TEC"][iterator] = dataTEC[iterator]["token"]
                   iterator++
                logger.logSuccess "Actualmente la BDD de +"+$scope.countrySelected.alternatename+" tiene: "+ dataTEC.length + " Tokens para Tecnicos."
                return
            $data4post = 
                country: $scope.countrySelected.country
                type: 'V'
            $http({url:REST_API.hostname+"/server/ajax/Tokens/listFiltered.php", method: "POST", data: JSON.stringify($data4post) })
            .success (dataDV) ->
                iterator=0
                while (iterator<dataDV.length)
                   $KeysAtDB["DV"][iterator] = dataDV[iterator]["token"]
                   iterator++
                logger.logSuccess "Actualmente la BDD de +"+$scope.countrySelected.alternatename+" tiene: "+ dataDV.length + " Tokens para Vendedores."
                return
            
            return

        # Erasing keys
        $scope.eraseKeys = ->
            $scope.Keys = {TEC:[] ,DV: []}
            logger.logSuccess "Se han borrado los Tokens generados para Tecnicos y Vendedores."
            return

        # Gerenetaring keys
        $scope.genKeys = ->
            
            conTEC=0
            conDV=0

            while (conTEC<5000 or conDV<5000)

                pass = generatePassword(12, false)

                # Formating correctly
                if pass.match(/\d+/g)==null
                    pass = pass.substr(0,4) + Math.floor((Math.random() * 9) + 1).toString() + pass.substr(4,7)
                if pass.indexOf("0")!=-1            
                    pass = pass.replace("0", Math.floor((Math.random() * 9) + 1).toString())
                if pass.indexOf("_")!=-1
                    pass = pass.replace(/_/g, Math.floor((Math.random() * 9) + 1).toString())
                # reducing the probabilities
                if pass.indexOf("_")!=-1
                    pass = pass.replace(/_/g, "0")

                pass = pass.toUpperCase()
                pass = pass.substr(0,4) + "-" + pass.substr(4,4)+ "-" + pass.substr(8,4)
                
                # can'T be repeated
                if $scope.Keys["TEC"].indexOf(pass) == -1 or $scope.Keys["DV"].indexOf(pass) == -1 or $KeysAtDB["TEC"].indexOf(pass) == -1 or $KeysAtDB["TEC"].indexOf(pass) == -1
                    # If the number is even. It's a Technicians code
                    if parseInt(pass.replace(/[^0-9]/g,'')) % 2 == 0
                        if conTEC<5000
                            $scope.Keys["TEC"][$scope.Keys["TEC"].length]=pass
                            conTEC++
                    else
                        if conDV<5000
                            $scope.Keys["DV"][$scope.Keys["DV"].length]=pass
                            conDV++

            logger.logSuccess "Se han generado automaticamente : "+ $scope.Keys["TEC"].length + " Y " + $scope.Keys["DV"].length + " Tokens para Tecnicos y Vendedores."
            console.log $scope.Keys 
            # con_ = 0
            # while con_ < $scope.Keys["TEC"].length
            #     if $scope.Keys["TEC"][con_].indexOf('_') != -1 or $scope.Keys["DV"][con_].indexOf('_') != -1
            #         console.log  con_+": "+ $scope.Keys["TEC"][con_] + " Y " + $scope.Keys["DV"][con_] 
            #     con_++
            
        # Gerenetaring keys
        $scope.saveKeys = ->
            $scope.data = { token: [], type: [] , country: ''};
            # Formating data
            iterator=0
            while iterator < $scope.Keys["TEC"].length+$scope.Keys["TEC"].length
                if iterator < $scope.Keys["TEC"].length
                    $scope.data["token"].push $scope.Keys["TEC"][iterator]
                    $scope.data["type"].push "T"
                else
                    $scope.data["token"].push $scope.Keys["DV"][iterator-$scope.Keys["TEC"].length]
                    $scope.data["type"].push "V"
                ++iterator
            $scope.data["country"]=$scope.countrySelected.country
        
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            console.log ($scope.data)
            $http({ url: REST_API.hostname+"/server/ajax/Tokens/addTokens.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                # console.log "Roy: " + JSON.stringify(postResponse)
                logger.logSuccess "Se han guardado exitosamente: "+ parseInt($scope.Keys["TEC"].length+$scope.Keys["DV"].length)+" Tokens."
                $scope.Keys = {TEC:[] ,DV: []}
            .error (postResponse) ->
                console.log "error"
            
        return    
        
])

.controller('compressorsCtrl', [
    'REST_API','$scope', '$filter', '$http', 'logger'
    (REST_API,$scope, $filter, $http, logger) ->
        # filter
        $scope.companies = []
        $scope.countries = []

        $scope.serials = []
        $scope.searchKeywords = ''
        $scope.filteredSerials = []
        $scope.row = ''

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageSerials = $scope.filteredSerials.slice(start, end)
            # console.log start
            # console.log end
            # console.log $scope.currentPageSerials

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
            $scope.filteredSerials = $filter('filter')($scope.serials, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredSerials = $filter('orderBy')($scope.serials, rowName)
            # console.log $scope.filteredSerials
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageSerials = []

        # init
        init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        init()

        # Roy
        # Drop File # set up drag-and-drop event 
        handleDragover = (e) ->
            e.stopPropagation()
            e.preventDefault()
            e.dataTransfer.dropEffect = "copy"
            return
        to_json = (workbook) ->
            # console.log "tojison begin!"
            result = {}
            workbook.SheetNames.forEach (sheetName) ->
                roa = XLSX.utils.sheet_to_row_object_array(workbook.Sheets[sheetName])
                result[sheetName] = roa  if roa.length > 0
            return result

        handleDrop = (e) ->
            # console.log "handleDroping"
            e.stopPropagation()
            e.preventDefault()
            files = e.dataTransfer.files
            i = undefined
            f = undefined
            i = 0
            f = files[i]

            while i isnt files.length
                reader = new FileReader()
                name = f.name
                reader.onload = (e) ->
                    data = e.target.result
                    # if binary string, read with type 'binary'
                    $scope.workbook = XLSX.read(data,
                        type: "binary"
                        )
                    # All Data of XLS is on workbook
                    $scope.workbookJSON = to_json($scope.workbook);
                    # SheetNames
                    $scope.SheetNames = []
                    index = 0
 
                    while index < $scope.workbook["SheetNames"].length
                        $scope.SheetNames.push String($scope.workbook["SheetNames"][index])
                        indexB = 0 
                        while indexB < $scope.workbookJSON[$scope.SheetNames[index]].length
                            $SheetSplitted = $scope.SheetNames[index].split "."
                            $scope.workbookJSON[$scope.SheetNames[index]][indexB].compressorID = $SheetSplitted[0]
                            # En caso de que lleven los ultimos digitos despues del /
                            # $scope.workbookJSON[$scope.SheetNames[index]][indexB].compressorID = $scope.SheetNames[index].replace ".", "/"
                            $scope.serials.push $scope.workbookJSON[$scope.SheetNames[index]][indexB]
                            ++indexB
                        ++index
                    $scope.$apply()
                    console.log "Sheets Encontradas"
                    console.log $scope.SheetNames
                    # console.log SheetNames[i] for i in SheetNames
                    # Adding Type
                    console.log $scope.workbookJSON
                    # indexC = 0
                    # while indexC < $scope.workbook.
                    # $scope.serials $scope.workbookJSON[$scope.SheetNames[0]]
                    # $scope.serials.push $scope.workbookJSON[$scope.SheetNames[1]]
                    setTimeout ->
                        $('#searchKeywords').focus()
                        angular.element('#orderUp').trigger('click')
                    , 675
                    return
                reader.readAsBinaryString f
                ++i
                return
        document.addEventListener "dropbox", handleDrop, false
        if dropbox.addEventListener
          dropbox.addEventListener "dragenter", handleDragover, false
          dropbox.addEventListener "dragover", handleDragover, false
          dropbox.addEventListener "drop", handleDrop, false
        console.log "terminó de cargar2"

        #Load Companies
        getImporterCompanies = ->
            $filters=
                isImporter: true
            $http({ url: REST_API.hostname+"/server/ajax/Company/listFiltered.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.companies =postResponse
            return
        getImporterCompanies()

        $scope.onlySerials=[]
        
        #Save Serials
        $scope.addSerials = ->
            $scope.data = { companySelected: [], serialsSelected: [] };

            # Arreglando serials sin no
            $serialsWithoutNo = []
            indexNo=0
            while indexNo < $scope.serials.length
                delete $scope.serials[indexNo].no
                $serialsWithoutNo.push $scope.serials[indexNo]
                $scope.onlySerials.push $scope.serials[indexNo]["serialID"]
                ++indexNo
            # console.log ($scope.data)
            $scope.data["companySelected"] = $scope.companySelected
            $scope.data["serialsSelected"] = $serialsWithoutNo
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            $http({ url: REST_API.hostname+"/server/ajax/Serials/addSerial.php", method: "POST", data: JSON.stringify($scope.data) })
            .success (postResponse) ->
                console.log "postResponse: " + postResponse
                $scope.saveBill()
            
        
        $scope.saveBill = ->
            $scope.data2insert=
                seller_userID : $scope.currentUser.userID
                number : $scope.number
                buyer_companyID: $scope.companySelected.companyID
                date: moment($scope.date).format('MM-DD-YYYY')
                serials: $scope.onlySerials
                description: $scope.currentUser.company.businessName+" >> "+$scope.companySelected.businessName
            console.log $scope.data2insert
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

])