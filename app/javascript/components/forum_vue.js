import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      message: 'Hello!',
      insertText: '',
      project: window.project
    }
  },
  
  methods: {
    insertMessage() {
      return this.message = this.insertText;
    }
  }
}
