<template>
  <div id="app">
      <ls-intro-section v-if="currentView == 'intro'" />
      <ls-end-section v-if="currentView == 'end'" />

      <div v-if="currentView == 'main'" class="main-view view-container">
        <div class="tasks-column">
          <h1 data-glyph="droplet" class="main-title oi"><br><span class="title">Lemonade<br>Startup</span></h1>
          <div class="jobs">
            <h3 data-glyph="briefcase" class="sub-title oi"><br><span class="title">Tasks</span></h3>
            <ls-job v-for="(task, index) in tasks" :key="task.id" :index="index" :task="task"></ls-job>
          </div>
          <div class="forecast">
            <h3 data-glyph="dashboard" class="sub-title oi"><br><span class="title">3-Day Forecast</span></h3>
            <div class="weather-conditions">
              <div v-for="(weather, index) in game.forecast" :key="index" class="weather-condition"><span :data-glyph="weather.icon" class="title oi">{{weather.description}}</span></div>
            </div>
          </div>
        </div>
        <div class="main-column">
          <div class="credits"><a href="https://twitter.com/share" data-lang="en" class="twitter-share-button">Tweet</a>
            <p class="developed-by">Made by&nbsp;<a target="_blank" href="http://twitter.com/kylnew" class="credit">Kyle</a>&nbsp;&amp;&nbsp;<a target="_blank" href="http://twitter.com/rlrichard" class="credit">Rob</a>&nbsp;at&nbsp;<a target="_blank" href="http://tojam.ca" class="credit">Toronto Game Jam #9</a>.&nbsp;<a target="_blank" href="http://github.com/bitwit/lemonade-startup" class="credit">Available on Github</a></p>
          </div>
          <div class="price-selector">
            <h3 class="price-title"><span class="title">Price: {{prices[price]}}</span></h3><strong class="price-mark low">$0</strong>
            <input type="range" :value="price" @change="priceChanged" min="0" max="9" class="price-input"><strong class="price-mark high">$10</strong>
          </div>
          <div class="days">
            <h2 class="sprint-title"><span class="title">Sprint &#35;{{sprint}} of {{maxSprints}}</span>
              <span v-if="countdownProgress &gt; 0" class="countdown">&nbsp;starts in {{countdownProgress/1000 | number(2)}}s</span>
            </h2>
            <div class="calendar">
              <ls-day v-for="(day, index) in sprintDays" :key="day.id" :index="index" :day="day" :progress="progress" :current-day="currentDay" class="day"></ls-day>
            </div>
            <div class="instructions">
              <h3>Instructions</h3>
              <ul class="instructions">
                <li class="instruction">Select different tasks by clicking or hotkeys (1-6) </li>
                <li class="instruction">Add tasks to the calendar by clicking days</li>
                <li class="instruction">Adjust the price dial as you please</li>
                <li class="instruction">Pay attention for timely optional events</li>
                <li class="instruction">Watch the weather forecast for hints at daily demand</li>
              </ul>
            </div>
          </div>
        </div>
        <div class="status-column">
          <div class="cash">
            <h3 :class="cashValuePositiveClass" data-glyph="dollar" class="cash-title oi"><br><span class="title">Cash</span></h3><strong :class="cashValuePositiveClass" class="cash-value">{{game.stats.cash | number(0)}}</strong>
            <h3 data-glyph="question-mark" :class="projectedValuePositiveClass" class="cash-title oi"><br><span class="title">Valuation</span></h3><strong :class="projectedValuePositiveClass" class="cash-value">{{game.stats.projectedValue | number(0)}}</strong>
          </div>
          <div class="assets">
            <h2 data-glyph="spreadsheet" class="section-title oi"><br><span class="title">Assets</span></h2>
            <div class="assets-container">
              <ls-asset v-for="asset in game.assets" :key="asset.name" :asset="asset"></ls-asset>
            </div><!--h3 Options
            <div :style="text-align: center;" class="debug-buttons">
              <label>Tick Speed</label>
              <input type="text" v-model="tickSpeed">
              <label>Countdown Progress</label>
              <input type="text" v-model="countdownProgress">
              <button @click="startSimulation()" class="hotkey"><span>Start Simulation</span></button>
              <button @click="autoPopulateDays()" class="hotkey"><span>Auto Populate</span></button>
            </div>
            <h3>Debug</h3>
            <dl>
              <dt>Development</dt>
              <dd>{{game.stats.development}}</dd>
              <dt>Design</dt>
              <dd>{{game.stats.design}}</dd>
              <dt>Marketing</dt>
              <dd>{{game.stats.marketing}}</dd>
              <dt>Research</dt>
              <dd>{{game.stats.research}}</dd>
              <dt>Sales</dt>
              <dd>{{game.stats.sales}}</dd>
              <dt>Fundraising</dt>
              <dd>{{game.stats.fundraising}}</dd>
              <dt>Productivity</dt>
              <dd>{{game.stats.productivity}}</dd>
            </dl>-->
          </div>
        </div>
        <div v-if="announcements.length &gt; 0" class="announcements">
          <ls-announcement v-for="event in announcements" :key="event.name" :event="event" @accept-event="acceptEvent()" @reject-event="rejectEvent()"></ls-announcement>
        </div>
      </div>
    </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Vuex from 'vuex'
import { AppState } from './State'
import AppStore from './AppStore'

import IntroSection from './components/IntroSection.vue'
import EndingSection from './components/EndSection.vue'

import AnnouncementView from './components/Announcement.vue'
import AssetView from './components/Asset.vue'
import DayView from './components/Day.vue'
import JobView from './components/Job.vue'
import TaskView from './components/Task.vue'

export default Vue.extend({
  name: 'App',
  components: {
    IntroSection,
    EndingSection,
    AnnouncementView, 
    AssetView, 
    DayView, 
    JobView, 
    TaskView
  },
 created: function () {
    console.log('created app');
    document.addEventListener('keydown', (e) => {
      if(!e.repeat) {
        this.handleKeyDown(e.key)
      }
    })
  },
  filters: {
    number: function (value: string, decimals: string) {
      if (!value) { return '' } 
      return parseFloat(value).toFixed(parseInt(decimals))
    }
  },
  computed: Vuex.mapState({
    currentView: function (state: AppState) { return state.currentView },
    tasks: function (state: AppState) { return state.tasks },
    prices: function (state: AppState) { return state.prices },
    price: function (state: AppState) { return state.price },
    countdownProgress: function (state: AppState) { return state.countdownProgress },
    progress: function (state: AppState) { return state.progress },
    currentDay: function (state: AppState) { return state.currentDay },
    sprint: function (state: AppState) { return state.sprint },
    sprintDays: function (state: AppState) { return state.sprintDays },
    maxSprints: function (state: AppState) { return state.maxSprints },
    game: function (state: AppState) { return state.businessObject },
    announcements: function (state: AppState) { return state.announcements },
    ending: function (state: AppState) { return state.ending },

    cashValuePositiveClass: function (state: AppState) {
      const obj: any = {}
      obj[`positive-${state.businessObject.stats.cash > 0}`] = true
      return obj
    },

    projectedValuePositiveClass: function (state: AppState) {
      const obj: any = {}
      obj[`positive-${state.businessObject.stats.projectedValue > 0}`] = true
      return obj
    }
  }),
  methods: {

    switchView: function (viewName: string) {
      this.$store.commit('switchView', viewName)
    },

    handleKeyDown: function (key: string) {
      console.log('keydown happened', key)
      switch (key) {
        case "1":
        case "2":
        case "3":
        case "4":
        case "5":
        case "6":
          this.$store.commit('setSelectedTaskIndex', (parseInt(key) - 1))
          break
        case "Escape":
          this.rejectEvent()
          break
        case " ":
          this.acceptEvent()
          break
      }
    },

    priceChanged: function (event: any) {
      const price: string | null = event?.srcElement?.value
      this.$store.commit('updatePrice', price)
    },

    getDayPlan: function () {
      console.log(this.sprintDays)
    },

    acceptEvent: function () {
      this.$store.dispatch('acceptEvent')
    },

    rejectEvent: function () {
      this.$store.dispatch('rejectEvent')
    },
  }

});
</script>

<style lang="scss">
#app {
  font-family: Avenir, Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
</style>
