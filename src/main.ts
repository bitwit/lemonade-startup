import Vue from 'vue'
import App from './App.vue'
import AppStore from './AppStore'

Vue.config.productionTip = false

new Vue({
  store: AppStore,
  render: h => h(App)
}).$mount('#app')
