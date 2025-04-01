import { createApp } from 'vue'
import { createPinia } from 'pinia'
import App from './App.vue'

// Create pinia (the store)
const pinia = createPinia()

// Create the app
const app = createApp(App)

// Use pinia
app.use(pinia)

// Mount the app
app.mount('#app') 