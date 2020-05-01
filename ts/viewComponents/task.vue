<template>
  <div class="task oi" :class="taskClasses">
    <span class="title">{{task.id}}</span>
    <span v-if="day.isInteractive" @click="removeTask($event, task)" class="delete oi" data-glyph="trash"></span>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Vuex from 'vuex'

Vue.component('ls-task', {
  props: {
    day: Object,
    task: Object
  },
  computed: {
    taskClasses: function () {
      const obj: any = {}
      obj["type-#{@task.id}"] = true
      return obj
    }
  },
  methods: {
    removeTask: function (e: Event) {
      if (e != null) {
        e.stopPropagation()
        e.preventDefault()
      }
      this.$store.commit('removeTaskFromDay', {task: this.task, day: this.day})
    }
  },
})
</script>
