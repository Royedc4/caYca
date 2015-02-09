'use strict';

angular.module('app', [
    # Angular modules
    'ngRoute'
    'ngAnimate'

    # 3rd Party Modules
    'ui.bootstrap'
    'easypiechart'
    'mgo-angular-wizard'
    'textAngular'
    'ui.tree'
    'ngMap'
    'ngTagsInput'

    # Custom modules
    'app.ui.ctrls'
    'app.ui.directives'
    'app.ui.services'
    'app.controllers'
    'app.directives'
    'app.form.validation'
    'app.ui.form.ctrls'
    'app.ui.form.directives'
    'app.tables'
    'app.compressors'
    'app.map'
    'app.task'
    'app.localization'
    'app.chart.ctrls'
    'app.chart.directives'
    'app.page.ctrls'
    'app.account.ctrls'
    'app.account.directives'
    'app.account.services'
    'app.company.ctrls'
    'app.admin.ctrls'
    'app.admin.directives'
    'app.admin.services'
    'app.records.ctrls'
    'app.records.directives'
    'app.records.services'
    'app.records.validation'
    ])

.constant 'AUTH_EVENTS',
    loginSuccess:       'auth-login-success'
    loginFailed:        'auth-login-failed'
    logoutSuccess:      'auth-logout-success'
    sessionTimeout:     'auth-session-timeout'
    notAuthenticated:   'auth-not-authenticated'
    notAuthorized:      'auth-not-authorized'

.constant 'USER_ROLES', 
    public:         'ALL'
    admin:          'ADM'
    technician:     'TEC'
    caYcaALM:       'CA'
    caYcaCGG:       'CGG'
    retailDV:       'DV'
    wholeSalerMA:   'MA'
    wholeSalerMAC:  'MAC'
    wholeSalerMG:   'MG'
    wholeSalerMGC:  'MGC'

.run([
    '$rootScope', 'AUTH_EVENTS', 'LoginService', 'logger', '$location'
    ($rootScope, AUTH_EVENTS, LoginService, logger, $location) ->
        $rootScope.$on '$routeChangeStart', (event,next) ->
            authorizedRoles = next.data.authorizedRoles
            if !LoginService.isAuthorized(authorizedRoles)
                event.preventDefault()
                if LoginService.isAuthenticated()
                    # User is not a11owed
                    $rootScope.$broadcast AUTH_EVENTS.notAuthorized
                    logger.logError('No tienes la permisología para acceder!')
                else
                    # User is not logged in
                    $rootScope.$broadcast AUTH_EVENTS.notAuthenticated
                    logger.logError('Debes estar autenticado para ingresar al sistema!')
                    $location.path '/accounts/signIn'
    ])

.config([
    '$routeProvider', 'USER_ROLES'
    ($routeProvider, USER_ROLES) ->
        $routeProvider
            # dashboard
            # .when(
            #     '/'
            #     redirectTo: '/accounts/signIn'
            #     controller: 'LoginCtrl'
            #     )
            .when(
                '/'
                redirectTo: '/accounts/signIn'
                data:
                    authorizedRoles: [USER_ROLES.public]
                )
            .when(
                '/dashboard'
                templateUrl: 'views/dashboard.html'
                data:
                    authorizedRoles: [
                        USER_ROLES.admin,
                        USER_ROLES.technician,
                        USER_ROLES.caYcaALM, 
                        USER_ROLES.caYcaCGG,
                        USER_ROLES.retailDV,
                        USER_ROLES.wholeSalerMA,
                        USER_ROLES.wholeSalerMAC,
                        USER_ROLES.wholeSalerMG,
                        USER_ROLES.wholeSalerMGC
                        ]
                )
            #Accounts
            .when(
                '/accounts/accountsCreation'
                templateUrl: 'views/accounts/accountsCreation.html'                
                data:
                    authorizedRoles: [
                        USER_ROLES.wholeSalerMGC,
                        USER_ROLES.admin
                    ]
                )
            .when(
                '/accounts/signIn'
                templateUrl: 'views/accounts/signIn.html'
                data:
                    authorizedRoles: [USER_ROLES.public]
                )
            .when(
                '/accounts/signUp'
                templateUrl: 'views/accounts/signUp.html'                
                data:
                    authorizedRoles: [USER_ROLES.public]
                )
            #Companies
            .when(
                '/companies/newCompany'
                templateUrl: 'views/companies/newCompany.html'                
                data:
                    authorizedRoles: [
                        USER_ROLES.wholeSalerMGC,
                        USER_ROLES.admin
                    ]
                )
            #Compressors
            .when(
                '/compressors/compressorsLoad'
                templateUrl: 'views/compressors/compressorsLoad.html'                
                data:
                    authorizedRoles: [
                        USER_ROLES.caYcaCGG,
                        USER_ROLES.admin
                    ]
                )
            # Records
            .when(
                '/records/recordInfo'
                templateUrl: 'views/records/recordInfo.html'                
                data:
                    authorizedRoles: [
                        USER_ROLES.wholeSalerMA,
                        USER_ROLES.admin
                    ]                
                )
            .when(
                '/records/makeInvoice'
                templateUrl: 'views/records/makeInvoice.html'                
                data:
                    authorizedRoles: [
                        USER_ROLES.wholeSalerMA,
                        USER_ROLES.admin
                    ]                
                )
            .when(
                '/records/makeLabels'
                templateUrl: 'views/records/makeLabels.html'
                data:
                    authorizedRoles: [
                        USER_ROLES.wholeSalerMA,
                        USER_ROLES.admin
                    ]                
                )

            # Redemptions
            .when(
                '/redemptions/newRedemption'
                templateUrl: 'views/redemptions/newRedemption.html'                
                )
            .when(
                '/redemptions/checkRedemptions'
                templateUrl: 'views/redemptions/checkRedemptions.html'                
                )
            .when(
                '/redemptions/checkPoints'
                templateUrl: 'views/redemptions/checkPoints.html'
                )  
            # Raffles                         
            .when(
                '/raffles/checkCoupons'
                templateUrl: 'views/raffles/checkCoupons.html'                
                )
            .when(
                '/raffles/results'
                templateUrl: 'views/raffles/results.html'                
                )
            # Promotions
            .when(
                '/promotions/newCoupon'
                templateUrl: 'views/promotions/newCoupon.html'                
                )
            .when(
                '/promotions/totalCoupons'
                templateUrl: 'views/promotions/totalCoupons.html'                
                )
            .when(
                '/promotions/totalPoints'
                templateUrl: 'views/promotions/totalPoints.html'                
                )
            .when(
                '/promotions/totalRedemptions'
                templateUrl: 'views/promotions/totalRedemptions.html'                
                )
            # Commons
            .when(
                '/pages/signin'
                templateUrl: 'views/pages/signin.html'                
                )
            .when(
                '/pages/features'
                templateUrl: 'views/pages/features.html'
                )
            .when(
                '/pages/signup'
                templateUrl: 'views/pages/signup.html'
                )
            .when(
                '/pages/forgot'
                templateUrl: 'views/pages/forgot-password.html'
                )
            .when(
                '/pages/lock-screen'
                templateUrl: 'views/pages/lock-screen.html'
                )
            .when(
                '/pages/profile'
                templateUrl: 'views/pages/profile.html'
                )
            .when(
                '/404'
                templateUrl: 'views/pages/404.html'
                data:
                    authorizedRoles: [USER_ROLES.public]
                )
            .when(
                '/pages/500'
                templateUrl: 'views/pages/500.html'
                )
            .when(
                '/pages/blank'
                templateUrl: 'views/pages/blank.html'
                )
            .when(
                '/pages/invoice'
                templateUrl: 'views/pages/invoice.html'
                )
            .when(
                '/pages/services'
                templateUrl: 'views/pages/services.html'
                )
            .when(
                '/pages/about'
                templateUrl: 'views/pages/about.html'
                )
            .when(
                '/pages/contact'
                templateUrl: 'views/pages/contact.html'
                )
            .otherwise(
                redirectTo: '/404'
                )

            # # UI Kit
            # .when(
            #     '/ui/typography'
            #     templateUrl: 'views/ui/typography.html'
            #     )
            # .when(
            #     '/ui/buttons'
            #     templateUrl: 'views/ui/buttons.html'
            #     )
            # .when(
            #     '/ui/icons'
            #     templateUrl: 'views/ui/icons.html'
            #     )
            # .when(
            #     '/ui/grids'
            #     templateUrl: 'views/ui/grids.html'
            #     )
            # .when(
            #     '/ui/widgets'
            #     templateUrl: 'views/ui/widgets.html'
            #     )
            # .when(
            #     '/ui/components'
            #     templateUrl: 'views/ui/components.html'
            #     )
            # .when(
            #     '/ui/timeline'
            #     templateUrl: 'views/ui/timeline.html'
            #     )
            # .when(
            #     '/ui/nested-lists'
            #     templateUrl: 'views/ui/nested-lists.html'
            #     )
            # .when(
            #     '/ui/pricing-tables'
            #     templateUrl: 'views/ui/pricing-tables.html'
            #     )

            # # Forms
            # .when(
            #     '/forms/elements'
            #     templateUrl: 'views/forms/elements.html'
            #     )
            # .when(
            #     '/forms/layouts'
            #     templateUrl: 'views/forms/layouts.html'
            #     )
            # .when(
            #     '/forms/validation'
            #     templateUrl: 'views/forms/validation.html'
            #     )
            # .when(
            #     '/forms/wizard'
            #     templateUrl: 'views/forms/wizard.html'
            #     )

            # # Maps
            # .when(
            #     '/maps/gmap'
            #     templateUrl: 'views/maps/gmap.html'
            #     )
            # .when(
            #     '/maps/jqvmap'
            #     templateUrl: 'views/maps/jqvmap.html'
            #     )

            # # Tables
            # .when(
            #     '/tables/static'
            #     templateUrl: 'views/tables/static.html'
            #     )
            # .when(
            #     '/tables/responsive'
            #     templateUrl: 'views/tables/responsive.html'
            #     )
            # .when(
            #     '/tables/dynamic'
            #     templateUrl: 'views/tables/dynamic.html'
            #     )

            # # Charts
            # .when(
            #     '/charts/others'
            #     templateUrl: 'views/charts/charts.html'
            #     )
            # .when(
            #     '/charts/morris'
            #     templateUrl: 'views/charts/morris.html'
            #     )
            # .when(
            #     '/charts/flot'
            #     templateUrl: 'views/charts/flot.html'
            #     )

            # # Mail
            # .when(
            #     '/mail/inbox'
            #     templateUrl: 'views/mail/inbox.html'
            #     )
            # .when(
            #     '/mail/compose'
            #     templateUrl: 'views/mail/compose.html'
            #     )
            # .when(
            #     '/mail/single'
            #     templateUrl: 'views/mail/single.html'
            #     )

            # # Tasks
            # .when(
            #     '/tasks'
            #     templateUrl: 'views/tasks/tasks.html'
            #     )

    ])
