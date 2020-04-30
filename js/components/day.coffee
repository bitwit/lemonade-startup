Vue.component 'ls-day', {
  template: """
    <div class="day" :class="dayClasses" @click="addSelectedTask()" @mouseover="isSelected = true" @mouseleave="isSelected = false">
        <div class="day-progress-meter" :style="progressMeterStyles"></div>
        <div v-if="day.result != null && (isShowingMessage || isSelected)" class="message">
          <ul class="items">
            <li class="oi" :data-glyph="day.result.weather.icon">
              <span class="title">Temperature</span>
              <span class="value">{{day.result.weather.temperature}}&deg;C</span>
            </li>
            <li class="oi" data-glyph="dollar">
              <span class="title">Price</span>
              <span class="value">{{day.price}}</span>
            </li>
            <li class="oi" data-glyph="people">
              <span class="title">Customers</span>
              <span class="value">{{day.result.customerCount}}</span>
            </li>
            <li class="oi" data-glyph="bar-chart">
              <span class="title">Cash</span>
              <span class="value" :class="deltaCashPositiveClass">{{day.result.cashDelta}}</span>
            </li>
          </ul>
        </div>
        <h5 class="day-name">{{day.name}}</h5>
        <ul class="task-placeholders">
          <li class="task-placeholder">AM</li>
          <li class="task-placeholder">PM</li>
        </ul>
        <ls-task v-for="(task, index) in day.tasks" :key="task.id + index" :task="task" :day="day"/>
    </div>
  """ 
  props:
    index: Number
    currentDay: Number
    progress: Number
    day: Object
  data: ->
    isSelected: no
    isShowingMessage: no
  computed: Vuex.mapState {
    dayClasses: (state) ->
      obj = {}
      obj["full-#{@day.tasks.length >= 2}"] = yes
      return obj
    deltaCashPositiveClass: (state) ->
      obj = {}
      obj["positive-#{@day.result.cashDelta > 0}"] = true
      return obj
    progressMeterStyles: (state) ->
      if @currentDay > @index
        width = "100%"
      else if @currentDay is @index
        width = (@progress * 10) + "%"
      else
        width = 0
      return {
        width: width
      }
  }
  methods:
    addSelectedTask: ->
      @$store.commit 'addSelectedTaskToDay', @day

    announce: () ->
      @isShowingMessage = yes
      $timeout(
        =>
          @isShowingMessage = no
      , 2500)
}


# appModule.directive 'lsDay', [ ->
#   replace: true
#   link: (scope, element, attrs, ctrl) ->
#     console.log 'sprint day link'
#     element.dayObject = scope.day

#   controller: [ "$scope", "$rootScope", "$timeout", ($scope, $rootScope, $timeout) ->
#     $scope.isSelected = no

#     $scope.taskOnDrop = (e, el) ->
#       task = el.draggable[0].taskObject
#       console.log 'new task for', $scope.day.name, task
#       $rootScope.$broadcast 'newTaskForDay', task, $scope.day

#     $scope.addSelectedTask = ->
#       if $scope.day.tasks.length < 2 and $scope.day.isInteractive
#         task = $scope.getCurrentSelectedTask()
#         $scope.day.tasks.push task
#         $rootScope.$broadcast 'newTaskForDay', task, $scope.day

#     $scope.sprintDayOptions = (index) ->
#       accept: (dragEl) ->
#         if $scope.currentDay >= index
#           return no
#         if $scope.day.$$hashKey is dragEl[0].attributes["data-day"].value
#           return no
#         if $scope.day.tasks.length >= 2
#           return no

#         return yes

#     $scope.progressMeterStyles = (index) ->
#       if $scope.currentDay > index
#         width = "100%"
#       else if $scope.currentDay is index
#         width = ($scope.progress * 10) + "%"
#       else
#         width = 0
#       return {
#         width: width
#       }

#     $scope.isShowingMessage = no

#     $scope.day.announce = (bizResult) ->
#       $scope.day.result = bizResult
#       $scope.isShowingMessage = yes
#       $timeout(
#         ->
#           $scope.isShowingMessage = no
#       , 2500)

#     $scope.removeTask = (e, task) ->
#       if e?
#         e.stopPropagation()
#         e.preventDefault()
#       leftOverTasks = []
#       for dayTask in $scope.day.tasks
#         if task != dayTask
#           leftOverTasks.push dayTask
#       $scope.day.tasks = leftOverTasks

#     $scope.$on 'newTaskForDay', ($e, task, day) ->
#       if day is $scope.day
#         return
#       $scope.removeTask null, task

#     $scope.$on 'taskMoved', ($e, task) ->
#       ###
#       console.log 'task is moving', task, $scope.day.tasks
#       ###
#   ]
#   template: """
#     <div class="day full-{{day.tasks.length >= 2}}" ng-click="addSelectedTask()" ng-mouseenter="isSelected=true;" ng-mouseleave="isSelected=false;" data-drop="true" ng-model="day.tasks" data-jqyoui-options="sprintDayOptions($index)" jqyoui-droppable="{onDrop:'taskOnDrop', multiple:true}">
#         <div class="day-progress-meter" ng-style="progressMeterStyles($index)"></div>
#         <div class="message showing-{{day.result != null && (isShowingMessage || isSelected) }}">
#           <ul class="items">
#             <li class="oi" data-glyph="{{day.result.weather.icon}}">
#               <span class="title">Temperature</span>
#               <span class="value">{{day.result.weather.temperature}}&deg;C</dd>
#             </li>
#             <li class="oi" data-glyph="dollar">
#               <span class="title">Price</span>
#               <span class="value">{{day.price | currency:"$"}}</dd>
#             </li>
#             <li class="oi" data-glyph="people">
#               <span class="title">Customers</span>
#               <span class="value">{{day.result.customerCount | number:0}}</span>
#             </li>
#             <li class="oi" data-glyph="bar-chart">
#               <span class="title">Cash</span>
#               <span class="value positive-{{day.result.cashDelta > 0}}">{{day.result.cashDelta | currency:"$"}}</dd>
#             </li>
#           </ul>
#         </div>
#         <h5 class="day-name">{{day.name}}</h5>
#         <ul class="task-placeholders">
#           <li class="task-placeholder">AM</li>
#           <li class="task-placeholder">PM</li>
#         </ul>
#         <div ng-repeat="task in day.tasks track by $index" ls-task></div>
#     </div>
#   """
# ]