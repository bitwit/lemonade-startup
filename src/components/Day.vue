<template>
  <div class="day" :class="dayClasses" @click="addSelectedTask()" @mouseover="isSelected = true" @mouseleave="isSelected = false">
        <div class="day-progress-meter" :style="progressMeterStyles"></div>
        <div v-if="day.result != null && (isShowingMessage || isSelected)" class="message">
          <ul class="items">
            <li class="oi" :data-glyph="day.result.weather.icon">
              <span class="title">Temperature</span>
              <span class="value">{{day.result.weather.temperature | number(0)}}&deg;C</span>
            </li>
            <li class="oi" data-glyph="dollar">
              <span class="title">Price</span>
              <span class="value">{{day.price | number(2)}}</span>
            </li>
            <li class="oi" data-glyph="people">
              <span class="title">Customers</span>
              <span class="value">{{day.result.customerCount | number(0)}}</span>
            </li>
            <li class="oi" data-glyph="bar-chart">
              <span class="title">Cash</span>
              <span class="value" :class="deltaCashPositiveClass">{{day.result.cashDelta | number(0)}}</span>
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
</template>

<script lang="ts">
import Vue from 'vue'

export default Vue.component('ls-day', {
  props: {
    index: Number,
    currentDay: Number,
    progress: Number,
    day: Object
  },
  data: function () {
    return {
      isSelected: false
    }
  },
  filters: {
    number: function (value: string, decimals: string) {
      if (!value) { return '' }
      return parseInt(value).toFixed(parseInt(decimals))
    }
  },
  computed: {
    progressMeterStyles: function () {
      let width:string
      if (this.currentDay > this.index) {
        width = "100%"
      }
      else if (this.currentDay === this.index) {
        width = (this.progress * 10) + "%"
      }
      else {
        width = "0"
      }
      return {
        width: width
      }
    },
    isShowingMessage: function () {
      this.index === (this.currentDay - 1)
    },
    dayClasses: function () {
      const obj: any = {}
      obj[`full-${this.day.tasks.length >= 2}`] = true
      return obj
    },
    deltaCashPositiveClass: function () {
      const obj: any = {}
      obj[`positive-${this.day.result.cashDelta > 0}`] = true
      return obj
    },
  },
  methods: {
    addSelectedTask: function () {
      this.$store.commit('addSelectedTaskToDay', this.day)
    }
  }
})
</script>