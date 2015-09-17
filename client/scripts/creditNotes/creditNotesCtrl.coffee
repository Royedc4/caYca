'use strict'
angular.module('app.creditNotes.ctrls', [])
.controller('newCreditNoteCtrl', [
    'REST_API','$scope', 'logger', '$http', '$window'
    (REST_API,$scope, logger, $http, $window) ->
        console.log 'newCreditNoteCtrl'      
])

.controller('listCreditNotesCtrl', [
    'REST_API','$scope', 'logger', '$http', '$filter', '$timeout'
    (REST_API,$scope, logger, $http, $filter, $timeout) ->
        console.log 'listCreditNotesCtrl'

])
