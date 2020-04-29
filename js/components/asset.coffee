Vue.component 'ls-asset', {
  template: """
  <div v-bind:class="typeClass" class="asset">
    <span v-bind:data-glyph="asset.icon" class="title oi">&nbsp;{{asset.name}}</span>
    <span v-if="asset.expiry > 0" class="expiry">{{asset.expiry}}</span>
  </div>
  """
  props:
    asset: Object
  computed:
    typeClass: () ->
      obj = {}
      obj["type-#{@asset.id}"] = yes
      return obj
}