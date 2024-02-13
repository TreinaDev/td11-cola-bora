import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      message: 'Hello!',
      insertText: '',
      project: window.project,
      posts: []
    }
  },
  mounted() {
    this.posts = window.posts.map(item => ({ title: item.title, body: item.body }));
  },
  methods: {
    insertMessage() {
      this.message = this.insertText;
    }
  }
}
