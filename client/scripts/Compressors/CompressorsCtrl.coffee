'use strict'

angular.module('app.compressors', [])

.controller('keysCtrl', [
    '$scope', 'logger', '$http'
    ($scope, logger, $http) ->

        $scope.countrySelected=''

        #Load Countries
        getCountries = ->
            $http.post("http://cayca:8888/server/ajax/Tables/getCountry.php").success (data) ->
                $scope.countries = data
                return
            return
        getCountries()

        $scope.Keys = {TEC:[] ,DV: []}

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
                if $scope.Keys["TEC"].indexOf(pass) == -1 or $scope.Keys["DV"].indexOf(pass) == -1
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
            $http({ url: "http://cayca:8888/server/ajax/Compressors/addTokens.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                console.log "Roy: " + JSON.stringify(postResponse)
                logger.logSuccess "Se han guardado exitosamente: "+ parseInt($scope.Keys["TEC"].length+$scope.Keys["DV"].length)+" Tokens."
            .error (postResponse) ->
                console.log "error"
            return
        return    
        
])

.controller('compressorsCtrl', [
    '$scope', '$filter', '$http'
    ($scope, $filter, $http) ->
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

                    return

                reader.readAsBinaryString f
                ++i
                return
        document.addEventListener "dropbox", handleDrop, false
        if dropbox.addEventListener
          dropbox.addEventListener "dragenter", handleDragover, false
          dropbox.addEventListener "dragover", handleDragover, false
          dropbox.addEventListener "drop", handleDrop, false
        
        #Load Countries
        getCountries = ->
            $http.post("http://cayca:8888/server/ajax/Tables/getCountry.php").success (data) ->
                $scope.countries = data
                return
            return
        getCountries()

        #Load Companies
        getCompanies = ->
            $http.post("http://cayca:8888/server/ajax/Tables/getCompany.php").success (data) ->
                $scope.companies = data
                return
            return
        getCompanies()

        #Save Serials
        $scope.addSerials = ->
            $scope.data = { companySelected: [], serialsSelected: [] };
            # Arreglando serials sin no
            $serialsWithoutNo = []
            indexNo=0
            while indexNo < $scope.serials.length
                delete $scope.serials[indexNo].no
                $serialsWithoutNo.push $scope.serials[indexNo]
                ++indexNo
            # console.log ($scope.data)
            $scope.data["companySelected"] = $scope.companySelected
            $scope.data["serialsSelected"] = $serialsWithoutNo
            $http.defaults.headers.post["Content-Type"] = "application/json"            
            console.log ($scope.data)
            $http({ url: "http://cayca:8888/server/ajax/Serials/addSerial.php", method: "POST", data: JSON.stringify(JSON.stringify($scope.data)) })
            .success (postResponse) ->
                console.log "success: " + postResponse
            return
        return
])