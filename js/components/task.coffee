Vue.component 'ls-task', {
  template: """
  <div class="task type-{{task.id}} oi">
    <span class="title">{{task.id}}</span>
    <span v-if="day.isInteractive" v-on:click="removeTask($event, task)" class="delete oi" data-glyph="trash"></span>
  </div>
  """
  props:
    day: Object
    task: Object
  methods:
    removeTask: ->
      @$emit 'remove-task', task
}

# appModule.directive 'lsTask', [ ->
#   replace: true
#   link: (scope, element, attrs, ctrl) ->
#     element[0].taskObject = scope.task

#   controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
#     $scope.dragStart = (e, el) ->
#       console.log 'dragStart', e, el
#       if !$scope.day.isInteractive
#         e.preventDefault()
#         e.stopPropagation()
#         el.helper.draggable "option", "disabled", yes

#     $scope.dragStop = ->
#       console.log 'task', $scope.day.name, $scope.task
#       $scope.$emit 'taskMoved', $scope.task
#   ]
#   template: """
#   <div class="task type-{{task.id}} oi" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert: 'invalid', placeholder:true}" ng-model="task" jqyoui-draggable="{index: {{$index}}, placeholder:'keep', onStart: 'dragStart', onStop: 'dragStop'}">
#     <span class="title">{{task.id}}</span>
#     <span ng-if="day.isInteractive" ng-click="removeTask($event, task)" class="delete oi" data-glyph="trash"></span>
#   </div>
#   """
# ]
