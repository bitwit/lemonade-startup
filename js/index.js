/*
  Device setup
*/

var Device, appModule, user_agent;

user_agent = navigator.userAgent;

Device = {
  isAndroid: user_agent.toLowerCase().indexOf("android") >= 0,
  isIOS: (user_agent.match(/iPhone/i) || user_agent.match(/iPod/i) || user_agent.match(/iPad/i)) != null
};

Device.isMobile = Device.isAndroid || Device.isIOS;

/*
  Begin Angular
*/


appModule = angular.module('appModule', ['ngRoute', 'ngTouch', 'ngAnimate']);

appModule.controller('MainController', [
  '$scope', function($scope) {
    return $scope.testMessage = "Successfully using AngularJS!";
  }
]);
