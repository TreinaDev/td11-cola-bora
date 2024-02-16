// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import * as bootstrap from "bootstrap"
import { createApp } from 'vue/dist/vue.esm-bundler.js'
import ForumComponent from './components/forum_vue.js'

createApp(ForumComponent).mount('#vue-app')
