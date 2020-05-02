<template>
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
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.component('ls-announcement', {
  props: {
    event: Object
  },
  computed: {
    typeClass: function () {
      const obj: any = {}
      obj[`type-${this.event.id}`] = true
      return obj
    }
  },
  methods: {
    acceptEvent: function () {
      this.$emit('accept-event')
    },
    rejectEvent: function () {
      this.$emit('reject-event')
    }
  }
})
</script>