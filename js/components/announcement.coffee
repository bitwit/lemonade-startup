Vue.component 'ls-announcement', {
  template: """
  <div v-bind:class="typeClass" class="announcement">
    <h2 v-bind:class="typeClass" class="event-title">
      <span class="title">{{event.name}}</span>
    </h2>
    <div v-bind:data-glyph="event.icon" class="oi"></div>
    <p class="description">{{event.description}}</p>
    <button v-bind:class="typeClass" v-on:click="acceptEvent()" class="accept">
      <span data-glyph="check" class="title oi">{{event.acceptText}}</span>
      <br>
      <span class="hotkey-button">space</span>
    </button>
    <button v-bind:class="typeClass" v-on:click="rejectEvent()" class="reject">
      <span data-glyph="x" class="title oi">{{event.rejectText}}</span>
      <br>
      <span class="hotkey-button">esc</span>
    </button>
  </div>
  """
  props:
    event: Object
  computed:
    typeClass: () ->
      obj = {}
      obj["type-#{@event.id}"] = yes
  methods:
    acceptEvent: ->
      console.log 'accept'

    rejectEvent: ->
      console.log 'reject'
}
