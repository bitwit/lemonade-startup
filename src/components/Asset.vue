<template>
  <div v-bind:class="typeClass" class="asset">
    <span v-bind:data-glyph="asset.icon" class="title oi">&nbsp;{{asset.name}}</span>
    <span v-if="asset.expiry > 0" class="expiry">{{asset.expiry}}</span>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.component('ls-asset', {
  props: {
    asset: Object
  },
  computed: {
    typeClass: function () {
      const obj: any = {}
      obj[`type-${this.asset.id}`] = true
      return obj
    }
  }
})
</script>