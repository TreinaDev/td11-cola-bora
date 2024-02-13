import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      project: window.project,
      posts: []
    }
  },

  mounted() {
    this.posts = window.posts.map(item => ({ title: item.title,
                                             body: item.body,
                                             author: item.user_name,
                                             date: item.created_at }));
  },

  computed:{
    filteredProjects() {
      const searchType = this.selectedFilter
      return this.posts.filter(post => {
        if (searchType === '') {
          return (
            post.title.toLowerCase().includes(this.searchText.toLowerCase()) ||
            post.body.toLowerCase().includes(this.searchText.toLowerCase())
          )
        } else {
          return post[searchType].toLowerCase().includes(this.searchText.toLowerCase());
        }
      })
    }
  },

  methods: {
    insertMessage() {
      this.message = this.insertText;
    }
  }
}
