<template>
  <div :class="typeClass" @click="onSelect()" :data-glyph="task.icon">
    <span class="title">{{task.name}}</span>
    <span class="hotkey-button">{{index + 1}}</span>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'

Vue.component('ls-job', {
  props: {
    index: Number,
    isSelected: Boolean,
    task: Object
  },
  computed: {
    typeClass: function () {
      const obj: any = {
        job: true,
        oi: true
      }
      obj["type-#{@task.id}"] = true
      obj["selected-#{@$store.state.selectedTaskIndex is @index}"] = true
      return obj
    }
  },
  methods: {
    onSelect: function () {
      this.$store.commit('setSelectedTaskIndex', this.index)
    }
  }
})
</script>
