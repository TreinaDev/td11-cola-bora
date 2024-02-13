import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      selectedPostId: null,
      selectedPost: null,
      project: window.project,
      posts: [],
      comments: []
    }
  },

  async mounted() {
    this.posts = window.posts.map(item => ({ id: item.id,
                                             title: item.title,
                                             body: item.body,
                                             author: item.user_name,
                                             date: item.created_at,
                                             comments: item.comments }));
    await showPostDetails;
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
    async insertMessage() {
      this.message = this.insertText;
    },

    async showPostDetails(id) {
      this.selectedPostId = id;

      this.selectedPost = this.posts.find(post => post.id === id);

      this.comments = this.selectedPost.comments
    }
  }
}
