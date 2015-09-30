'use strict'
angular.module('app.creditNotes.ctrls', [])
.controller('newCreditNoteCtrl', [
    'REST_API','$scope', 'logger', '$http', '$window', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $window, $filter, $timeout) ->
        console.log 'newCreditNoteCtrl'   

        # Form Stuff 
        $scope.date=new Date()

        $scope.redeems = []
        $scope.searchKeywords = ''
        $scope.filteredRedeems = []
        $scope.row = ''

        $scope.seleccionada=null
        $scope.selectedRow=null

        $scope.getInfo = (index) ->
            $scope.selectedRow = index;
            console.log(this.redeem)
            $scope.seleccionada=this.redeem

        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageRedeems = $scope.filteredRedeems.slice(start, end)

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
            $scope.filteredRedeems = $filter('filter')($scope.redeems, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredRedeems = $filter('orderBy')($scope.redeems, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[0]
        $scope.currentPage = 1
        $scope.currentPageRedeems = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        $scope.getSellersRedeems = ->
            $filters=
                country: $scope.currentUser.country.country
                registryDate: $scope.date
            $http({ url: REST_API.hostname+"/server/ajax/redeems/4creditNote.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                $scope.redeems=postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    # $('#searchKeywords').focus()
                    angular.element('#orderIDRedeemUP').trigger('click')
                    angular.element('#orderIDRedeemDW').trigger('click')
                , 250
        $scope.getSellersRedeems()

        # Form Methods
        $scope.revert = ->
            $scope.creditNoteForm.$setPristine()
        $scope.canRevert = ->
            return !$scope.creditNoteForm.$pristine
        $scope.canSubmit = ->
            return $scope.creditNoteForm.$valid 
        
        $scope.saveCreditNote = ->
            $filters=
                companyID: $scope.seleccionada.companyID
                createdBy_userID: $scope.currentUser.userID
                registryDate: $scope.date
                creationDate: $scope.date
                comment: ''
                country: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/creditNotes/new.php", method: "POST", data: JSON.stringify($filters) })
            .success (postResponse) ->
                console.log postResponse
                setTimeout ->
                    $scope.getSellersRedeems()        
                , 675
            
            
])

.controller('listCreditNotesCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        console.log 'listCreditNotesCtrl'
        # Definition of objets
        $scope.creditNotes = []
        $scope.searchKeywords = ''
        $scope.filteredCreditNotes = []
        $scope.row = ''
        $scope.seleccionada=null
        $scope.selectedRow=null

        $scope.getInfo = (index) ->
            $scope.selectedRow = index;
            console.log(this.creditNotes)
            $scope.seleccionada=this.creditNotes


        $scope.select = (page) ->
            start = (page - 1) * $scope.numPerPage
            end = start + $scope.numPerPage
            $scope.currentPageCreditNotes = $scope.filteredCreditNotes.slice(start, end)

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
            $scope.filteredCreditNotes = $filter('filter')($scope.creditNotes, $scope.searchKeywords)
            $scope.onFilterChange()

        # orderBy
        $scope.order = (rowName)->
            if $scope.row == rowName
                return
            $scope.row = rowName
            $scope.filteredCreditNotes = $filter('orderBy')($scope.creditNotes, rowName)
            $scope.onOrderChange()

        # pagination
        $scope.numPerPageOpt = [3, 5, 10, 20]
        $scope.numPerPage = $scope.numPerPageOpt[2]
        $scope.currentPage = 1
        $scope.currentPageCreditNotes = []

        # init
        $scope.init = ->
            $scope.search()
            $scope.select($scope.currentPage)
        $scope.init()

        
        getCreditNotes = ->
            $filters=
                countryID: $scope.currentUser.country.country
            $http({ url: REST_API.hostname+"/server/ajax/creditNotes/list.php", method: "POST", data: JSON.stringify($filters) })
                .success (postResponse) ->
                    $scope.creditNotes =postResponse
                # Only way to make react on filter to show items on table
                setTimeout ->
                    $('#searchKeywords').focus()
                    angular.element('#creditNoteIDUP').trigger('click')
                    if $scope.filteredCreditNotes.length==0
                        logger.logError "No se encontraron notas de credito registradas."
                    else
                        logger.logSuccess "Tiene "+$scope.creditNotes.length+" notas de credito registradas."
                , 250
            return
        getCreditNotes()



])
