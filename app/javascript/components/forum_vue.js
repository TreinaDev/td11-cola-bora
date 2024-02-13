import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      selectedPostId: null,
      project: window.project,
      posts: [],
      comments: []
    }
  },

  mounted() {
    this.posts = window.posts.map(item => ({ title: item.title,
                                             body: item.body,
                                             author: item.user_name,
                                             date: item.created_at }));
  },

  computed:{
    filteredPosts() {
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
    },

    showPostDetails(post_id) {
      this.selectedPostId = post_id
      selectedPost = this.posts.filter(post => post.id == post_id)

      const comments = this.comments.filter(comment => comment.post_id === post_id);

    }
  }
}
