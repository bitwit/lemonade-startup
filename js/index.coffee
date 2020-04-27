###
  Convenience Functions
###

#Clone @ http://stackoverflow.com/questions/11060631/how-do-i-clone-copy-an-instance-of-an-object-in-coffeescript
clone = (obj) ->
  return obj  if obj is null or typeof (obj) isnt "object"
  temp = new obj.constructor()
  for key of obj
    temp[key] = clone(obj[key])
  temp

#Suffle @ http://jsfromhell.com/array/shuffle [v1.0]
shuffle = (array) ->
  counter = array.length;
  #While there are elements in the array
  while (counter > 0)
    #Pick a random index
    index = Math.floor(Math.random() * counter)
    #Decrease counter by 1
    counter--
    #And swap the last element with it
    temp = array[counter]
    array[counter] = array[index]
    array[index] = temp
  return array;

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
appModule = angular.module 'appModule', ['cfp.hotkeys', 'ngRoute', 'ngTouch', 'ngAnimate', 'ngDragDrop']

appModule.config ['hotkeysProvider', (hotkeysProvider) ->
  console.log 'configuring cheat sheet to no'
  hotkeysProvider.includeCheatSheet = no
]


appModule.controller "RootController", ["$rootScope", ($rootScope) ->
  $rootScope.currentView = "intro"
  $rootScope.switchView = (viewName) ->
    $rootScope.currentView = viewName

  $rootScope.restart = ->
    window.location.reload()
]

appModule.controller 'IntroController', ['$scope', ($scope) ->

]

appModule.controller 'MainController', ['$scope', '$rootScope', '$timeout', 'BusinessObject', 'hotkeys', ($scope, $rootScope, $timeout, bizObj, hotkeys) ->
  $scope.testMessage = "Successfully using AngularJS!"

  hotkeys.add "1", "Development", -> $scope.selectedTaskIndex = 0
  hotkeys.add "2", "Research", -> $scope.selectedTaskIndex = 1
  hotkeys.add "3", "Marketing", -> $scope.selectedTaskIndex = 2
  hotkeys.add "4", "Design", -> $scope.selectedTaskIndex = 3
  hotkeys.add "5", "Sales", -> $scope.selectedTaskIndex = 4
  hotkeys.add "6", "Fundraising", -> $scope.selectedTaskIndex = 5
  hotkeys.add "space", "Resume/Accept", ->
    console.log "resume simulation"
    $scope.acceptEvent()
  hotkeys.add "esc", "Resume/Reject", ->
    console.log "resume simulation"
    $scope.rejectEvent()

  $scope.sprintDays = [
    #first week
    {name: "Monday", tasks: [], isInteractive: yes, price: null}
    {name: "Tuesday", tasks: [], isInteractive: yes, price: null}
    {name: "Wednesday", tasks: [], isInteractive: yes, price: null}
    {name: "Thursday", tasks: [], isInteractive: yes, price: null}
    {name: "Friday", tasks: [], isInteractive: yes, price: null}
    {name: "Saturday", tasks: [], isInteractive: yes, price: null}
    {name: "Sunday", tasks: [], isInteractive: yes, price: null}
    #second week
    {name: "Monday", tasks: [], isInteractive: yes, price: null}
    {name: "Tuesday", tasks: [], isInteractive: yes, price: null}
    {name: "Wednesday", tasks: [], isInteractive: yes, price: null}
    {name: "Thursday", tasks: [], isInteractive: yes, price: null}
    {name: "Friday", tasks: [], isInteractive: yes, price: null}
    {name: "Saturday", tasks: [], isInteractive: yes, price: null}
    {name: "Sunday", tasks: [], isInteractive: yes, price: null}
  ]

  $scope.tasks = [
    new DevelopmentCard()
    new ResearchCard()
    new MarketingCard()
    new DesignCard()
    new SalesCard()
    new FundraisingCard()
  ]

  $scope.prices =[
    0
    0.5
    1
    1.5
    2
    3
    4
    5
    7
    10
  ]

  $scope.price = 3
  $scope.sprint = 1
  $scope.maxSprints = 4
  $scope.currentDay = -1
  $scope.progress = 0
  $scope.timerPromise = null
  $scope.hasStarted = no
  $scope.tickSpeed = 30
  $scope.selectedTaskIndex = 0
  $scope.countdownProgress = 0
  $scope.announcements = []

  $scope.setSelectedTaskIndex = (index) ->
    $scope.selectedTaskIndex = index

  $scope.getCurrentSelectedTask = ->
    task = $scope.tasks[$scope.selectedTaskIndex] #$scope.tasks.slice $scope.selectedTaskIndex, 1
    return clone task

  $scope.taskListOptions =
    accept: (dragEl) ->
      return no
    helper: 'clone'

  $scope.getDayPlan = ->
    console.log $scope.sprintDays

  $scope.startCountdown = ->
    $scope.countdownProgress = 10000
    $timeout $scope.tickCountdown, $scope.tickSpeed

  $scope.tickCountdown = ->
    $scope.countdownProgress -= $scope.tickSpeed
    if $scope.countdownProgress <= 0
      $scope.countdownProgress = 0
      $scope.startSimulation()
    else
      $timeout $scope.tickCountdown, $scope.tickSpeed

  $scope.startSimulation = ->
    $scope.hasStarted = yes
    $scope.currentDay = 0
    day = $scope.sprintDays[$scope.currentDay]
    day.price = $scope.prices[$scope.price]
    day.isInteractive = no
    $scope.tick()

  $scope.autoPopulateDays = ->
    for day in $scope.sprintDays
      while day.tasks.length < 2
        $scope.selectedTaskIndex = Math.floor((Math.random() * 6))
        day.tasks.push $scope.getCurrentSelectedTask()

  $scope.acceptEvent = ->
    event = $scope.announcements.shift()
    event.onAccept bizObj
    bizObj.assets.unshift event
    $scope.resumeSimulation()

  $scope.rejectEvent = ->
    event = $scope.announcements.shift()
    event.onReject bizObj
    $scope.resumeSimulation()

  $scope.resumeSimulation = ->
    if $scope.hasStarted and !$scope.timerPromise?
      $scope.announcements.length = 0
      $scope.tick()

  $scope.tick = ->
    $scope.progress += 0.1
    didCompleteDay = no
    if $scope.progress > 10
      didCompleteDay = yes
      shouldPause = bizObj.dayComplete $scope.sprintDays[$scope.currentDay]
      $scope.progress = 0.1
      $scope.currentDay++

    if $scope.currentDay > 13
      console.log 'sprint simulation complete'
      bizObj.sprintComplete $scope.sprint
      $timeout $scope.nextSprint, 3000
    else
      if didCompleteDay
        day = $scope.sprintDays[$scope.currentDay]
        newPrice = $scope.prices[$scope.price]
        day.price = newPrice
        day.isInteractive = no

      if !shouldPause
        $scope.timerPromise = $timeout $scope.tick, $scope.tickSpeed
      else
        $scope.timerPromise = null

  $scope.nextSprint = ->
    $scope.sprint++
    if $scope.sprint > $scope.maxSprints
      endResult = bizObj.processEndGame()
      console.log 'end game result', endResult
      $rootScope.ending = endResult
      $rootScope.switchView 'end'
    else
      $scope.currentDay = -1
      $scope.progress = 0
      for day in $scope.sprintDays
        day.result = null
        day.tasks.length = 0
        day.isInteractive = yes
      $scope.startCountdown()

  $scope.$on 'eventCardOccured', ($e, eventCard) ->
    $scope.announcements.length = 0
    $scope.announcements.push eventCard
    console.log 'announcements', $scope.announcements

  $scope.$on 'taskMoved', ($e, task) ->
    console.log 'main controller task moved'

  $scope.startCountdown() #start countdown once loaded
]
