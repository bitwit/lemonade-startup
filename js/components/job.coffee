Vue.component 'ls-job', {
  template: """
  <div class="job type-{{task.id}} selected-{{isSelected}} oi" v-on:click="onSelect()" data-glyph="{{task.icon}}">
    <span class="title">{{task.name}}</span>
    <span class="hotkey-button">{{hotkeyButton}}</span>
  </div>
  """
  props:
    hotkeyButton: Number
    index: Number
    isSelected: Boolean
    task: Object
  methods:
    onSelect: ->
      @$emit 'select-job'
}

# appModule.directive 'lsJob', [ ->
#   replace: true
#   link: (scope, element, attrs, ctrl) ->
#     element[0].taskObject = scope.task

#   controller: [ "$scope", "$rootScope", ($scope, $rootScope) ->
#     $scope.dragStop = ->
#       $scope.$emit 'taskMoved', $scope.task

#     $scope.selected = (index) ->
#       $scope.setSelectedTaskIndex index
#   ]
#   template: """
#   <div class="job type-{{task.id}} selected-{{selectedTaskIndex == $index}} oi" ng-click="selected($index)" data-glyph="{{task.icon}}" data-drag="{{true}}" data-day="{{day.$$hashKey}}" data-jqyoui-options="{revert:'invalid'}" ng-model="task" jqyoui-draggable="{index: {{$index}}, onStop: 'dragStop', placeholder:'keep'}">
#     <span class="title">{{task.name}}</span>
#     <span class="hotkey-button">{{$index + 1}}</span>
#   </div>
#   """
# ]
