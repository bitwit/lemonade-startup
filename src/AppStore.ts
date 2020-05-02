import Vue from 'vue'
import Vuex from 'vuex'
import { AppState } from './State'
import { Day } from './classes/Day'
import { Card } from './cards/job-cards'
import { EventCard } from './cards/event-cards'
import { clone } from './utilities'

Vue.use(Vuex)

export default new Vuex.Store({
  state: new AppState(),
  
  mutations: {
    startSimulation: function (state: AppState) {
      state.hasStarted = true
      state.currentDay = 0
      const day = state.sprintDays[state.currentDay]
      day.price = state.prices[state.price]
      day.isInteractive = true
    },
    resetCountdown: function (state: AppState) {
      state.countdownProgress = 2000 //10000 
    },
    clearAnnouncements: function (state: AppState) {
      state.announcements.length = 0
    },
    switchView: function (state: AppState, newView: string) {
      state.currentView = newView
    },
    nextSprint: function (state: AppState) {
      state.sprint++
      if(state.sprint > state.maxSprints) {
        const endResult = state.businessObject.processEndGame()
        state.ending = endResult
        state.currentView = 'end'
      }
      else {
        state.currentDay = -1
        state.progress = 0
        for (let i = 0; i < state.sprintDays.length; i++) {
          const day = state.sprintDays[i]
          day.result = null
          day.tasks.length = 0
          day.isInteractive = true
        }
      }
    },
    autoPopulateDays: function (state: AppState) {
      for (let i = 0; i < state.sprintDays.length; i++) {
        const day = state.sprintDays[i]
        while(day.tasks.length < 2) {
          state.selectedTaskIndex = Math.floor((Math.random() * 6))
          day.tasks.push(clone(state.tasks[state.selectedTaskIndex]))
        }
      }
    },
    tickCountdown: function (state: AppState) {
      state.countdownProgress -= state.tickSpeed
      if(state.countdownProgress <= 0) {
        state.countdownProgress = 0
      }
    },
    tick: function (state: AppState) {
      state.progress += 0.1
      let didCompleteDay = false
      if(state.progress > 10) {
        didCompleteDay = true
        const day = state.sprintDays[state.currentDay]
        const result = state.businessObject.dayComplete(
          day,
          (event: EventCard) => {
            state.announcements.length = 0
            state.announcements.push(event)
          }
        )
        day.result = result.dayHistory
        state.isPaused = result.didTriggerEvent
        state.progress = 0.1
        state.currentDay++
      }

      if(state.currentDay > 13) {
        state.businessObject.sprintComplete(state.sprint)
      }
      else {
        if(didCompleteDay) {
          const day = state.sprintDays[state.currentDay]
          const newPrice = state.prices[state.price]
          day.price = newPrice
          day.isInteractive = false
        }
      }
    },

    unpause: function (state: AppState) {
      state.isPaused = false
    },

    updatePrice: function (state: AppState, price: number) {
      state.price = price
    },

    setSelectedTaskIndex: function (state: AppState, index: number) {

      state.selectedTaskIndex = index
    },

    addSelectedTaskToDay: function (state: AppState, day: Day) {
      if (day.tasks.length < 2 && day.isInteractive) {
        const task = clone(state.tasks[state.selectedTaskIndex])
        day.tasks.push(task)
      }
    },

    removeTaskFromDay: function (state: AppState, payload) {
      console.log('remove task', arguments)
      const leftOverTasks: Card[] = []
      for (let i = 0; i < payload.day.tasks.length; i++) {
        const task = payload.day.tasks[i]
        if(payload.task != task) {
          leftOverTasks.push(task)
        }
      }
      payload.day.tasks = leftOverTasks
    },
    
    acceptFirstEvent: function (state: AppState) {
      const event = state.announcements.shift()
      if(!event) { return }
      event.onAccept(state.businessObject)
      state.businessObject.assets.unshift(event) // Add it to our current assets
    },

    rejectFirstEvent: function (state: AppState) {
      const event = state.announcements.shift()
      event?.onReject(state.businessObject)
    }
  },
      
  actions: {
    startCountdown: function (context) {
      context.commit('resetCountdown')
      context.dispatch('tickCountdown')
    },

    tickCountdown: function (context) {
      context.commit('tickCountdown')
      if(context.state.countdownProgress <= 0) {
        context.dispatch('startSimulation')
      }
      else {
        setTimeout( () => {
          context.dispatch('tickCountdown')
        }, context.state.tickSpeed)
      }
    },

    startSimulation: function (context) {
      context.commit('startSimulation')
      context.dispatch('tick')
    },

    tick: function (context) {
      context.commit('tick')
      if(context.state.currentDay > 13) {
        setTimeout(() => { 
          context.dispatch('nextSprint') 
        }, 3000)
      }
      else if(!context.state.isPaused) {
        setTimeout(() => {
          context.dispatch('tick')
        }, context.state.tickSpeed)
      }
    },

    acceptEvent: function (context) {
      context.commit('acceptFirstEvent')
      context.dispatch('resumeSimulation')
    },

    rejectEvent: function (context) {
      context.commit('rejectFirstEvent')
      context.dispatch('resumeSimulation')
    },

    resumeSimulation: function (context) {
      if(context.state.hasStarted) {
        context.commit('clearAnnouncements')
        context.commit('unpause')
        context.dispatch('tick')
      }
    },
    nextSprint: function (context) {
      context.commit('nextSprint')
      context.dispatch('startCountdown')
    }
  }
})


