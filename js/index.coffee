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
appModule = angular.module 'appModule', ['ngRoute', 'ngTouch', 'ngAnimate', 'ngDragDrop']

appModule.controller 'MainController', ['$scope', '$rootScope', '$timeout', 'BusinessObject', ($scope, $rootScope,$timeout, bizObj) ->
  $scope.testMessage = "Successfully using AngularJS!"

  $scope.taskListOptions =
    accept: (dragEl) ->
      return no
    helper: 'clone'

  $scope.sprintDays = [
    #first week
    {name: "Monday", tasks: []}
    {name: "Tuesday", tasks: []}
    {name: "Wednesday", tasks: []}
    {name: "Thursday", tasks: []}
    {name: "Friday", tasks: []}
    {name: "Saturday", tasks: []}
    {name: "Sunday", tasks: []}
    #second week
    {name: "Monday", tasks: []}
    {name: "Tuesday", tasks: []}
    {name: "Wednesday", tasks: []}
    {name: "Thursday", tasks: []}
    {name: "Friday", tasks: []}
    {name: "Saturday", tasks: []}
    {name: "Sunday", tasks: []}
  ]

  $scope.prices =[
    "0.00"
    "0.50"
    "1.00"
    "1.50"
    "2.00"
    "3.00"
    "4.00"
    "5.00"
    "7.00"
    "10.00"
  ]

  $scope.price = 3

  $scope.sprint = 1
  $scope.progress = 0
  $scope.currentDay = -1
  $scope.timerPromise = null

  $scope.getDayPlan = ->
    console.log $scope.sprintDays

  $scope.startSimulation = ->
    $scope.currentDay = 0
    $scope.sprintDays[$scope.currentDay].price = $scope.prices[$scope.price]
    $scope.tick()

  $scope.resumeSimulation = ->
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
        $scope.sprintDays[$scope.currentDay].price = $scope.prices[$scope.price]
      if !shouldPause
        $scope.timerPromise = $timeout $scope.tick, 40

  $scope.nextSprint = ->
    $scope.sprint++
    $scope.currentDay = -1
    $scope.progress = 0
    for day in $scope.sprintDays
      day.tasks = []

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
    $scope.setTasks()

  $scope.setTasks()
]

appModule.directive 'lsDay', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    console.log 'sprint day link'

  controller: [ "$scope", "$rootScope", "$timeout", ($scope, $rootScope, $timeout) ->
    $scope.sprintDayDraggableOut = (e, el) ->
      #console.log 'draggable out', e, el, $scope.day

    $scope.taskOnDrop = (e, el, a) ->
      #console.log 'task on drop', e, el, $scope.day, a

    $scope.message = null

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
        width =  ($scope.progress * 10) + "%"
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


    $scope.$on 'taskMoved', ($e, task) ->
      console.log 'task is moving', task, $scope.day.tasks
      leftOverTasks = []
      for dayTask in $scope.day.tasks
        console.log dayTask
        if task != dayTask
          leftOverTasks.push dayTask
      $scope.day.tasks = leftOverTasks

  ]
  template: """
    <div data-drop="true" ng-model="day.tasks" data-jqyoui-options="sprintDayOptions($index)" jqyoui-droppable="{onDrop:'taskOnDrop', multiple:true}" class="day">
        <div class="day-progress-meter" ng-style="progressMeterStyles($index)"></div>
        <div class="message showing-{{(message != null)}}">
          <span class="value">{{message}}</span>
        </div>
        <h5 class="day-name">{{day.name}}</h5>
        <div ng-repeat="task in day.tasks track by $id(task)" ls-task></div>
    </div>
  """
]

appModule.directive 'lsJob', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    console.log 'task link'

  controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
    $scope.dragStop = ->
      $scope.$emit 'taskMoved', $scope.task
  ]
  template: """
  <div class="job type-{{task.id}} oi" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert:'invalid'}" ng-model="task" jqyoui-draggable="{index: {{$index}}, onStop: 'dragStop', placeholder:'keep'}">
    <span>{{task.name}}</span>
  </div>
  """
]

appModule.directive 'lsTask', [ ->
  replace: true
  link: (scope, element, attrs, ctrl) ->
    console.log 'task link'

  controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
    $scope.dragStop = ->
      console.log 'task', $scope.day.name, $scope.task
      $scope.$emit 'taskMoved', $scope.task
  ]
  template: """
  <div class="task type-{{task.id}} oi" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert: 'invalid', placeholder:true}" ng-model="task" jqyoui-draggable="{index: {{$index}}, placeholder:'keep', onStop: 'dragStop'}">
    <span>{{task.name}}</span>
  </div>
  """
]