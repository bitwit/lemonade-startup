Vue.use(Vuex)

store = new Vuex.Store({
  state: 
    sprintDays: [
      #first week
      {id: "1", name: "Monday", tasks: [], isInteractive: yes, price: null}
      {id: "2", name: "Tuesday", tasks: [], isInteractive: yes, price: null}
      {id: "3", name: "Wednesday", tasks: [], isInteractive: yes, price: null}
      {id: "4", name: "Thursday", tasks: [], isInteractive: yes, price: null}
      {id: "5", name: "Friday", tasks: [], isInteractive: yes, price: null}
      {id: "6", name: "Saturday", tasks: [], isInteractive: yes, price: null}
      {id: "7", name: "Sunday", tasks: [], isInteractive: yes, price: null}
      #second week
      {id: "8", name: "Monday", tasks: [], isInteractive: yes, price: null}
      {id: "9", name: "Tuesday", tasks: [], isInteractive: yes, price: null}
      {id: "10", name: "Wednesday", tasks: [], isInteractive: yes, price: null}
      {id: "11", name: "Thursday", tasks: [], isInteractive: yes, price: null}
      {id: "12", name: "Friday", tasks: [], isInteractive: yes, price: null}
      {id: "13", name: "Saturday", tasks: [], isInteractive: yes, price: null}
      {id: "14", name: "Sunday", tasks: [], isInteractive: yes, price: null}
    ]
    tasks: [
      new DevelopmentCard()
      new ResearchCard()
      new MarketingCard()
      new DesignCard()
      new SalesCard()
      new FundraisingCard()
    ]
    prices: [
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
    currentView: 'intro'
    price:  3
    sprint: 1
    maxSprints: 4
    currentDay: -1
    progress: 0
    hasStarted: no
    tickSpeed: 30
    isPaused: no
    selectedTaskIndex: 0
    countdownProgress: 0
    announcements: []
    businessObject: new BusinessObject()
    ending: null
  
  mutations: {
    setSelectedTaskIndex: (state, index) ->
      state.selectedTaskIndex = index

    startSimulation: (state) ->
      state.hasStarted = yes
      state.currentDay = 0
      day = state.sprintDays[state.currentDay]
      day.price = state.prices[state.price]
      day.isInteractive = no

    resetCountdown: (state) ->
      state.countdownProgress = 2000 #10000 

    clearAnnouncements: (state) ->
      state.announcements.length = 0

    switchView: (state, newView) ->
      state.currentView = newView

    nextSprint: (state) ->
      state.sprint++
      if state.sprint > state.maxSprints
        endResult = state.businessObject.processEndGame()
        console.log 'end game result', endResult
        state.ending = endResult
        state.currentView = 'end'
      else
        state.currentDay = -1
        state.progress = 0
        for day in state.sprintDays
          day.result = null
          day.tasks.length = 0
          day.isInteractive = yes

    autoPopulateDays: (state) ->
      for day in state.sprintDays
        while day.tasks.length < 2
          state.selectedTaskIndex = Math.floor((Math.random() * 6))
          day.tasks.push state.getCurrentSelectedTask()
    
    acceptFirstEvent: (state) ->
      event = state.announcements.shift()
      event.onAccept state.businessObject
      # Add it to our current assets
      state.businessObject.assets.unshift event

    rejectFirstEvent: (state) ->
      event = state.announcements.shift()
      event.onReject state.businessObject

    tickCountdown: (state) ->
      state.countdownProgress -= state.tickSpeed
      if state.countdownProgress <= 0
        state.countdownProgress = 0

    tick: (state) ->
      state.progress += 0.1
      didCompleteDay = no
      if state.progress > 10
        didCompleteDay = yes
        day = state.sprintDays[state.currentDay]
        result = state.businessObject.dayComplete(
          day,
          (event) ->
            state.announcements.length = 0
            state.announcements.push event
            console.log 'announcements', state.announcements
        )
        day.result = result.dayHistory
        state.isPaused = result.didTriggerEvent
        state.progress = 0.1
        state.currentDay++

      if state.currentDay > 13
        console.log 'sprint simulation complete'
        state.businessObject.sprintComplete state.sprint
      else
        if didCompleteDay
          day = state.sprintDays[state.currentDay]
          newPrice = state.prices[state.price]
          day.price = newPrice
          day.isInteractive = no

    unpause: (state) ->
      state.isPaused = no
  }

  actions: {
    startCountdown: (context) ->
      context.commit 'resetCountdown'
      context.dispatch 'tickCountdown'

    tickCountdown: (context) ->
      context.commit 'tickCountdown'
      if context.state.countdownProgress <= 0
        context.dispatch 'startSimulation'
      else
        setTimeout( => 
          context.dispatch 'tickCountdown'
        , context.state.tickSpeed)

    startSimulation: (context) ->
      context.commit 'startSimulation'
      context.dispatch 'tick'

    tick: (context) ->
      context.commit 'tick'
      if context.state.currentDay > 13
        setTimeout( => 
          context.dispatch 'nextSprint'
        , 3000)
      else if !context.state.isPaused
        setTimeout( => 
          context.dispatch 'tick'
        , context.state.tickSpeed)

    acceptEvent: (context) ->
      context.commit 'acceptFirstEvent'
      context.dispatch 'resumeSimulation'

    rejectEvent: (context) ->
      context.commit 'rejectFirstEvent'
      context.dispatch 'resumeSimulation'

    resumeSimulation: (context) ->
      if context.state.hasStarted
        context.commit 'clearAnnouncements'
        context.commit 'unpause'
        context.dispatch 'tick'

    nextSprint: (context) ->
      context.commit 'nextSprint'
      context.dispatch 'startCountdown'
  }
})

new Vue
  el: '#app',
  store: store,
  created: () ->
    console.log 'App has loaded', @
  computed:
    Vuex.mapState({
      currentView: "currentView"
      tasks: "tasks"
      prices: "prices"
      price: "price"
      forecast: "forecast"
      countdownProgress: "countdownProgress"
      progress: "progress"
      currentDay: "currentDay"
      sprint: "sprint"
      sprintDays: "sprintDays"
      maxSprints: "maxSprints"
      game: "businessObject"
      announcements: "announcements"

      cashValuePositiveClass: (state) ->
        obj = {}
        name = "positive-#{state.businessObject.stats.cash > 0}"
        obj[name] = true
        return obj

      projectedValuePositiveClass: (state) -> 
        obj = {}
        name = "positive-#{state.businessObject.stats.projectedValue > 0}"
        obj[name] = true
        return obj
    })

  methods:
    newGame: () ->
      @$store.commit 'switchView', 'main'
      @$store.dispatch 'startCountdown'

    switchView: (viewName) ->
      @$store.commit 'switchView', viewName

    getCurrentSelectedTask: ->
      task = @$store.state.tasks[@$store.state.selectedTaskIndex]
      return clone task

    getDayPlan: ->
      console.log $scope.sprintDays

    acceptEvent: ->
      @$store.dispatch 'acceptEvent'

    rejectEvent: ->
      @$store.dispatch 'rejectEvent'

    restart: ->
      window.location.reload()

# appModule = angular.module 'appModule', ['cfp.hotkeys', 'ngRoute', 'ngTouch', 'ngAnimate', 'ngDragDrop']

# appModule.config ['hotkeysProvider', (hotkeysProvider) ->
#   console.log 'configuring cheat sheet to no'
#   hotkeysProvider.includeCheatSheet = no
# ]

# appModule.controller 'MainController', ['$scope', '$rootScope', '$timeout', 'BusinessObject', 'hotkeys', ($scope, $rootScope, $timeout, businessObject, hotkeys) ->
#   $scope.testMessage = "Successfully using AngularJS!"

#   hotkeys.add "1", "Development", -> $scope.selectedTaskIndex = 0
#   hotkeys.add "2", "Research", -> $scope.selectedTaskIndex = 1
#   hotkeys.add "3", "Marketing", -> $scope.selectedTaskIndex = 2
#   hotkeys.add "4", "Design", -> $scope.selectedTaskIndex = 3
#   hotkeys.add "5", "Sales", -> $scope.selectedTaskIndex = 4
#   hotkeys.add "6", "Fundraising", -> $scope.selectedTaskIndex = 5
#   hotkeys.add "space", "Resume/Accept", ->
#     console.log "resume simulation"
#     $scope.acceptEvent()
#   hotkeys.add "esc", "Resume/Reject", ->
#     console.log "resume simulation"
#     $scope.rejectEvent()

#   $scope.sprintDays = [
#     #first week
#     {name: "Monday", tasks: [], isInteractive: yes, price: null}
#     {name: "Tuesday", tasks: [], isInteractive: yes, price: null}
#     {name: "Wednesday", tasks: [], isInteractive: yes, price: null}
#     {name: "Thursday", tasks: [], isInteractive: yes, price: null}
#     {name: "Friday", tasks: [], isInteractive: yes, price: null}
#     {name: "Saturday", tasks: [], isInteractive: yes, price: null}
#     {name: "Sunday", tasks: [], isInteractive: yes, price: null}
#     #second week
#     {name: "Monday", tasks: [], isInteractive: yes, price: null}
#     {name: "Tuesday", tasks: [], isInteractive: yes, price: null}
#     {name: "Wednesday", tasks: [], isInteractive: yes, price: null}
#     {name: "Thursday", tasks: [], isInteractive: yes, price: null}
#     {name: "Friday", tasks: [], isInteractive: yes, price: null}
#     {name: "Saturday", tasks: [], isInteractive: yes, price: null}
#     {name: "Sunday", tasks: [], isInteractive: yes, price: null}
#   ]

#   $scope.tasks = [
#     new DevelopmentCard()
#     new ResearchCard()
#     new MarketingCard()
#     new DesignCard()
#     new SalesCard()
#     new FundraisingCard()
#   ]

#   $scope.prices =[
#     0
#     0.5
#     1
#     1.5
#     2
#     3
#     4
#     5
#     7
#     10
#   ]

#   $scope.price = 3
#   $scope.sprint = 1
#   $scope.maxSprints = 4
#   $scope.currentDay = -1
#   $scope.progress = 0
#   $scope.timerPromise = null
#   $scope.hasStarted = no
#   $scope.tickSpeed = 30
#   $scope.selectedTaskIndex = 0
#   $scope.countdownProgress = 0
#   $scope.announcements = []

#   $scope.setSelectedTaskIndex = (index) ->
#     $scope.selectedTaskIndex = index

#   $scope.getCurrentSelectedTask = ->
#     task = $scope.tasks[$scope.selectedTaskIndex] #$scope.tasks.slice $scope.selectedTaskIndex, 1
#     return clone task

#   $scope.taskListOptions =
#     accept: (dragEl) ->
#       return no
#     helper: 'clone'

#   $scope.getDayPlan = ->
#     console.log $scope.sprintDays

#   $scope.startCountdown = ->
#     $scope.countdownProgress = 10000
#     $timeout $scope.tickCountdown, $scope.tickSpeed

#   $scope.tickCountdown = ->
#     $scope.countdownProgress -= $scope.tickSpeed
#     if $scope.countdownProgress <= 0
#       $scope.countdownProgress = 0
#       $scope.startSimulation()
#     else
#       $timeout $scope.tickCountdown, $scope.tickSpeed

#   $scope.startSimulation = ->
#     $scope.hasStarted = yes
#     $scope.currentDay = 0
#     day = $scope.sprintDays[$scope.currentDay]
#     day.price = $scope.prices[$scope.price]
#     day.isInteractive = no
#     $scope.tick()

#   $scope.autoPopulateDays = ->
#     for day in $scope.sprintDays
#       while day.tasks.length < 2
#         $scope.selectedTaskIndex = Math.floor((Math.random() * 6))
#         day.tasks.push $scope.getCurrentSelectedTask()

#   $scope.acceptEvent = ->
#     event = $scope.announcements.shift()
#     event.onAccept businessObject
#     businessObject.assets.unshift event
#     $scope.resumeSimulation()

#   $scope.rejectEvent = ->
#     event = $scope.announcements.shift()
#     event.onReject businessObject
#     $scope.resumeSimulation()

#   $scope.resumeSimulation = ->
#     if $scope.hasStarted and !$scope.timerPromise?
#       $scope.announcements.length = 0
#       $scope.tick()

#   $scope.tick = ->
#     $scope.progress += 0.1
#     didCompleteDay = no
#     if $scope.progress > 10
#       didCompleteDay = yes
#       shouldPause = businessObject.dayComplete $scope.sprintDays[$scope.currentDay]
#       $scope.progress = 0.1
#       $scope.currentDay++

#     if $scope.currentDay > 13
#       console.log 'sprint simulation complete'
#       businessObject.sprintComplete $scope.sprint
#       $timeout $scope.nextSprint, 3000
#     else
#       if didCompleteDay
#         day = $scope.sprintDays[$scope.currentDay]
#         newPrice = $scope.prices[$scope.price]
#         day.price = newPrice
#         day.isInteractive = no

#       if !shouldPause
#         $scope.timerPromise = $timeout $scope.tick, $scope.tickSpeed
#       else
#         $scope.timerPromise = null

#   $scope.nextSprint = ->
#     $scope.sprint++
#     if $scope.sprint > $scope.maxSprints
#       endResult = businessObject.processEndGame()
#       console.log 'end game result', endResult
#       $rootScope.ending = endResult
#       $rootScope.switchView 'end'
#     else
#       $scope.currentDay = -1
#       $scope.progress = 0
#       for day in $scope.sprintDays
#         day.result = null
#         day.tasks.length = 0
#         day.isInteractive = yes
#       $scope.startCountdown()

#   $scope.$on 'eventCardOccured', ($e, eventCard) ->
#     $scope.announcements.length = 0
#     $scope.announcements.push eventCard
#     console.log 'announcements', $scope.announcements

#   $scope.$on 'taskMoved', ($e, task) ->
#     console.log 'main controller task moved'

#   $scope.startCountdown() #start countdown once loaded
# ]
