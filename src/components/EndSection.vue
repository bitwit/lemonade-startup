<template>
  <div class="end-view view-container">
    <div class="ending">
      <h2 class="end-title">{{ending.name}}</h2>
      <span :data-glyph="ending.icon" class="oi ending-icon"></span>
      <p class="ending-description">{{ending.description}}</p>
      <div class="cash">
        <h3 :class="cashValuePositiveClass" class="cash-title">
          <span class="title">Final Cash</span>
        </h3>
        <strong :class="cashValuePositiveClass" class="cash-value">{{game.stats.cash | number}}</strong>
        <h3 :class="projectedValuePositiveClass" class="cash-title">
          <span class="title">Final Valuation</span>
        </h3>
        <strong :class="projectedValuePositiveClass" class="cash-value">{{game.stats.projectedValue | number}}</strong>
      </div>
      <h3 class="end-title">Game Over</h3>
      <button @click="restart()" class="game-start">
        <span data-glyph="reload" class="title oi">&nbsp;Restart</span>
      </button>
    </div>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
import Vuex from 'vuex'
import { AppState } from '../State'

export default Vue.component('ls-end-section', {
  filters: {
    number: function (value: string, decimals: string) {
      if (!value) { return '' } 
      return parseFloat(value).toFixed(parseInt(decimals))
    }
  },
  computed: Vuex.mapState({
    game: function (state: AppState) { return state.businessObject },
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
    restart: function () {
      window.location.reload()
    }
  }
})
</script>