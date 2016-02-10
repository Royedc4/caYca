'use strict'
angular.module('app.landing.ctrls', [])
.controller('landingCtrl', [
    'REST_API','$scope', 'logger', '$http', '$window', '$document', '$animate'
    (REST_API,$scope, logger, $http, $window, $document, $animate) ->
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



        # window.addEventListener 'hashchange', ->
        #     scrollBy 0, -70

        # $animate.enabled(false);
        # $scope.toSection3 = ->
        #     console.log "3"
        #     section3 = angular.element(document.getElementById('bot'))
        #     document.scrollToElementAnimated section3

        # $(document).ready ->
        #     $('a[href^="#"]').on 'click', (e) ->
        #         e.preventDefault()
        #         target = @hash
        #         $target = $(target)
        #         $('html, body').stop().animate { 'scrollTop': $target.offset().top }, 900, 'swing', ->
        #             window.location.hash = target
        #             console.log "estuve aqui"
])



