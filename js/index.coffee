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
    bizObj.stats.cash -= event.cost
    bizObj.stats.equity -= event.equity
    bizObj.assets.unshift event
    $scope.resumeSimulation()

  $scope.rejectEvent = ->
    event = $scope.announcements.shift()
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

appModule.directive 'lsDay', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    console.log 'sprint day link'
    element.dayObject = scope.day

  controller: [ "$scope", "$rootScope", "$timeout", ($scope, $rootScope, $timeout) ->
    $scope.isSelected = no

    $scope.taskOnDrop = (e, el) ->
      task = el.draggable[0].taskObject
      console.log 'new task for', $scope.day.name, task
      $rootScope.$broadcast 'newTaskForDay', task, $scope.day

    $scope.addSelectedTask = ->
      if $scope.day.tasks.length < 2 and $scope.day.isInteractive
        task = $scope.getCurrentSelectedTask()
        $scope.day.tasks.push task
        $rootScope.$broadcast 'newTaskForDay', task, $scope.day

    $scope.sprintDayOptions = (index) ->
      accept: (dragEl) ->
        if $scope.currentDay >= index
          return no
        if $scope.day.$$hashKey is dragEl[0].attributes["data-day"].value
          return no
        if $scope.day.tasks.length >= 2
          return no

        return yes

    $scope.progressMeterStyles = (index) ->
      if $scope.currentDay > index
        width = "100%"
      else if $scope.currentDay is index
        width = ($scope.progress * 10) + "%"
      else
        width = 0
      return {
        width: width
      }

    $scope.isShowingMessage = no

    $scope.day.announce = (bizResult) ->
      $scope.day.result = bizResult
      $scope.isShowingMessage = yes
      $timeout(
        ->
          $scope.isShowingMessage = no
      , 2500)

    $scope.removeTask = (e, task) ->
      if e?
        e.stopPropagation()
        e.preventDefault()
      leftOverTasks = []
      for dayTask in $scope.day.tasks
        if task != dayTask
          leftOverTasks.push dayTask
      $scope.day.tasks = leftOverTasks

    $scope.$on 'newTaskForDay', ($e, task, day) ->
      if day is $scope.day
        return
      $scope.removeTask null, task

    $scope.$on 'taskMoved', ($e, task) ->
      ###
      console.log 'task is moving', task, $scope.day.tasks
      ###
  ]
  template: """
    <div class="day full-{{day.tasks.length >= 2}}" ng-click="addSelectedTask()" ng-mouseenter="isSelected=true;" ng-mouseleave="isSelected=false;" data-drop="true" ng-model="day.tasks" data-jqyoui-options="sprintDayOptions($index)" jqyoui-droppable="{onDrop:'taskOnDrop', multiple:true}">
        <div class="day-progress-meter" ng-style="progressMeterStyles($index)"></div>
        <div class="message showing-{{day.result != null && (isShowingMessage || isSelected) }}">
          <span class="oi" data-glyph="{{day.result.weather.icon}}"></span>
          <span class="temperature">{{day.result.weather.temperature}}&deg;C</span>
          <ul class="items">
            <li class="oi" data-glyph="dollar">
              <span class="title">Price</span>
              <span class="value">{{day.price | currency:"$"}}</dd>
            </li>
            <li class="oi" data-glyph="people">
              <span class="title">Customers</span>
              <span class="value">{{day.result.stats.averageDemand | number:0}}</span>
            </li>
            <li class="oi" data-glyph="bar-chart">
              <span class="title">Cash</span>
              <span class="value positive-{{day.result.cashDelta > 0}}">{{day.result.cashDelta | currency:"$"}}</dd>
            </li>
          </ul>
        </div>
        <h5 class="day-name">{{day.name}}</h5>
        <div ng-repeat="task in day.tasks track by $index" ls-task></div>
    </div>
  """
]

appModule.directive 'lsJob', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    element[0].taskObject = scope.task

  controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
    $scope.dragStop = ->
      $scope.$emit 'taskMoved', $scope.task

    $scope.selected = (index) ->
      $scope.setSelectedTaskIndex index
  ]
  template: """
  <div class="job type-{{task.id}} selected-{{selectedTaskIndex == $index}} oi" ng-click="selected($index)" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert:'invalid'}" ng-model="task" jqyoui-draggable="{index: {{$index}}, onStop: 'dragStop', placeholder:'keep'}">
    <span class="title">{{task.name}}</span>
    <span class="hotkey-button">{{$index + 1}}</span>
  </div>
  """
]

appModule.directive 'lsTask', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    element[0].taskObject = scope.task

  controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
    $scope.dragStart = (e, el) ->
      console.log 'dragStart', e, el
      if !$scope.day.isInteractive
        e.preventDefault()
        e.stopPropagation()
        el.helper.draggable "option", "disabled", yes

    $scope.dragStop = ->
      console.log 'task', $scope.day.name, $scope.task
      $scope.$emit 'taskMoved', $scope.task
  ]
  template: """
  <div class="task type-{{task.id}} oi" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert: 'invalid', placeholder:true}" ng-model="task" jqyoui-draggable="{index: {{$index}}, placeholder:'keep', onStart: 'dragStart', onStop: 'dragStop'}">
    <span class="title">{{task.id}}</span>
    <span ng-if="day.isInteractive" ng-click="removeTask($event, task)" class="delete oi" data-glyph="trash"></span>
  </div>
  """
]