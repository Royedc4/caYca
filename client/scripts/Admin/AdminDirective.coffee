'use strict';

angular.module('app.admin.directives', [])

.directive('uiTime', [ ->
    return {
        restrict: 'A'
        link: (scope, ele) ->
            startTime = ->
                today = new Dat e()
                h = today.getHours()
                m = today.getMinutes()
                s = today.getSeconds()

                m = checkTime(m)
                s = checkTime(s)

                time = h+":"+m+":"+s
                ele.html(time)
                t = setTimeout(startTime,500)
            checkTime = (i) -> # add a zero in front of numbers<10
                if (i<10) then i = "0" + i
                return i

            startTime()
    }
])

.directive('uiWeather', [ ->
    return {
        restrict: 'A'
        link: (scope, ele, attrs) ->
            color = attrs.color
            # CLEAR_DAY, CLEAR_NIGHT, PARTLY_CLOUDY_DAY, PARTLY_CLOUDY_NIGHT, CLOUDY
            # RAIN, SLEET, SNOW, WIND, FOG
            icon = Skycons[attrs.icon]

            skycons = new Skycons({
                "color": color
                "resizeClear": true
            })

            skycons.add(ele[0], icon)
            skycons.play()
    }
])

