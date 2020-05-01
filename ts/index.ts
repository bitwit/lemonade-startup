import Vue from 'vue'
import Vuex from 'vuex'
import { AppState } from './State'
import { appStore } from './AppStore'
import AnnouncementComponent from './viewComponents/announcement.vue'

new Vue({
  store: appStore,
  el: "#app",
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
      return parseInt(value).toFixed(parseInt(decimals))
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
      obj["positive-#{state.businessObject.stats.cash > 0}"] = true
      return obj
    },

    projectedValuePositiveClass: function (state: AppState) {
      const obj: any = {}
      obj["positive-#{state.businessObject.stats.projectedValue > 0}"] = true
      return obj
    }
  }),
  methods: {

    newGame: function () {
      this.$store.commit('switchView', 'main')
      this.$store.dispatch('startCountdown')
    },

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

    restart: function () {
      window.location.reload()
    }
  }
})
