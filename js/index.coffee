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

appModule.controller 'MainController', ['$scope', '$rootScope', '$timeout', 'BusinessObject', 'hotkeys', ($scope, $rootScope, $timeout, bizObj, hotkeys) ->
  $scope.testMessage = "Successfully using AngularJS!"

  hotkeys.add "1", "Development", -> $scope.selectedTaskIndex = 0
  hotkeys.add "2", "Research", -> $scope.selectedTaskIndex = 1
  hotkeys.add "3", "Marketing", -> $scope.selectedTaskIndex = 2
  hotkeys.add "4", "Design", -> $scope.selectedTaskIndex = 3
  hotkeys.add "5", "Sales", -> $scope.selectedTaskIndex = 4
  hotkeys.add "6", "Fundraising", -> $scope.selectedTaskIndex = 5
  hotkeys.add "space", "Resume/Confirm", ->
    console.log "resume simulation"
    $scope.resumeSimulation()

  $scope.selectedTaskIndex = 0

  $scope.setSelectedTaskIndex = (index) ->
    $scope.selectedTaskIndex = index

  $scope.getCurrentSelectedTask = ->
    task = $scope.tasks[$scope.selectedTaskIndex] #$scope.tasks.slice $scope.selectedTaskIndex, 1
    return clone task

  $scope.taskListOptions =
    accept: (dragEl) ->
      return no
    helper: 'clone'

  $scope.sprintDays = [
    #first week
    {name: "Monday", tasks: [], isInteractive: yes}
    {name: "Tuesday", tasks: [], isInteractive: yes}
    {name: "Wednesday", tasks: [], isInteractive: yes}
    {name: "Thursday", tasks: [], isInteractive: yes}
    {name: "Friday", tasks: [], isInteractive: yes}
    {name: "Saturday", tasks: [], isInteractive: yes}
    {name: "Sunday", tasks: [], isInteractive: yes}
    #second week
    {name: "Monday", tasks: [], isInteractive: yes}
    {name: "Tuesday", tasks: [], isInteractive: yes}
    {name: "Wednesday", tasks: [], isInteractive: yes}
    {name: "Thursday", tasks: [], isInteractive: yes}
    {name: "Friday", tasks: [], isInteractive: yes}
    {name: "Saturday", tasks: [], isInteractive: yes}
    {name: "Sunday", tasks: [], isInteractive: yes}
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
  $scope.progress = 0
  $scope.currentDay = -1
  $scope.timerPromise = null
  $scope.hasStarted = no

  $scope.getDayPlan = ->
    console.log $scope.sprintDays

  $scope.startSimulation = ->
    $scope.hasStarted = yes
    $scope.currentDay = 0
    day = $scope.sprintDays[$scope.currentDay]
    day.price = $scope.prices[$scope.price]
    day.isInteractive = no
    $scope.tick()

  $scope.resumeSimulation = ->
    if $scope.hasStarted and !$scope.timerPromise?
      $scope.announcements = []
      $scope.tick()

  $scope.tick = ->
    $scope.progress += 0.1
    didCompleteDay = no
    if $scope.progress > 10
      didCompleteDay = yes
      shouldPause = bizObj.dayComplete $scope.sprintDays[$scope.currentDay]
      $scope.progress = 0.1
      $scope.currentDay++

    if $scope.currentDay >= 14
      console.log 'sprint simulation complete'
      bizObj.sprintComplete $scope.sprint
      $scope.nextSprint()
    else
      if didCompleteDay
        day = $scope.sprintDays[$scope.currentDay]
        day.price = $scope.prices[$scope.price]
        day.isInteractive = no

      if !shouldPause
        $scope.timerPromise = $timeout $scope.tick, 40
      else
        $scope.timerPromise = null

  $scope.nextSprint = ->
    $scope.sprint++
    $scope.currentDay = -1
    $scope.progress = 0
    for day in $scope.sprintDays
      day.tasks = []
      isInteractive = yes

  $scope.setTasks = ->
    $scope.tasks = [
      new DevelopmentCard()
      new ResearchCard()
      new MarketingCard()
      new DesignCard()
      new SalesCard()
      new FundraisingCard()
    ]

  $rootScope.announceEvent = (event) ->
    $rootScope.announcements = [event]

  $scope.$on 'taskMoved', ($e, task) ->
    console.log 'main controller task moved'
    #$scope.setTasks()

  $scope.setTasks()
]

appModule.directive 'lsDay', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    console.log 'sprint day link'
    element.dayObject = scope.day

  controller: [ "$scope", "$rootScope", "$timeout", ($scope, $rootScope, $timeout) ->
    $scope.sprintDayDraggableOut = (e, el) ->
      #console.log 'draggable out', e, el, $scope.day

    $scope.taskOnDrop = (e, el) ->
      task = el.draggable[0].taskObject
      console.log 'new task for', $scope.day.name, task
      $rootScope.$broadcast 'newTaskForDay', task, $scope.day

    $scope.message = null

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

    $scope.day.announce = (text) ->
      console.log 'announcing text', $scope.day, text
      $scope.message = text
      $timeout(
        ->
          $scope.message = null
      , 1000)

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
    <div class="day full-{{day.isInteractive}}" ng-click="addSelectedTask()" data-drop="true" ng-model="day.tasks" data-jqyoui-options="sprintDayOptions($index)" jqyoui-droppable="{onDrop:'taskOnDrop', multiple:true}">
        <div class="day-progress-meter" ng-style="progressMeterStyles($index)"></div>
        <div class="message showing-{{(message != null)}}">
          <span class="value">{{message}}</span>
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
    <span ng-if="day.isInteractive" ng-click="removeTask($event, task)" class="delete">X</span>
  </div>
  """
]