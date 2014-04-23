###
  Device setup
###
user_agent = navigator.userAgent;
Device =
  isAndroid: user_agent.toLowerCase().indexOf("android") >= 0
  isIOS: (user_agent.match(/iPhone/i) || user_agent.match(/iPod/i) || user_agent.match(/iPad/i))?
Device.isMobile = Device.isAndroid or Device.isIOS

###
  Begin Angular
###
appModule = angular.module 'appModule', ['ngRoute','ngTouch', 'ngAnimate']

appModule.controller 'MainController', ['$scope', ($scope) ->
  $scope.testMessage = "Successfully using AngularJS!"
]