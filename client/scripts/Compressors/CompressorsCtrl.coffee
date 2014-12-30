'use strict'

angular.module('app.compressors', [])

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
        getTask = ->
            $http.post("http://cayca:8888/server/ajax/Tables/getCountry.php").success (data) ->
                $scope.countries = data
                return
            return
        getTask()

                #Load Countries
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