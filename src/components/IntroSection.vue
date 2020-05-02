<template>
  <div class="intro-view view-container">
    <h1 class="intro-title">
      <span data-glyph="droplet" class="lemon-drop oi"></span>
      <br>1 Lemonade Stand
      <br>
      <br>$50 Life Savings
      <br>
      <br>Time to bootstrap this baby
      <br>into a Lemonade Startup
    </h1>
    <button @click="newGame()" class="game-start">
      <span data-glyph="check" class="title oi">&nbsp;Let's Get Agile</span>
    </button>
  </div>
</template>

<script lang="ts">
import Vue from 'vue'
export default Vue.component('ls-intro-section', {
  methods: {
    newGame: function () {
      this.$store.commit('switchView', 'main')
      this.$store.dispatch('startCountdown')
    }
  }
})
</script>