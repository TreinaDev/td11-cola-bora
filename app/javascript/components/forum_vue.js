import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      selectedPost: null,
      project: window.project,
      posts: [],
      comments: [],
      activePage: 'postsIndex'
    }
  },

  mounted() {
    this.loadPosts();
  },

  computed:{
    filteredPosts() {
      this.resetPostDetails();

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
    loadPosts(){
      this.posts = window.posts.map(item => ({ id: item.id,
        title: item.title,
        body: item.body,
        author: item.user_name,
        date: item.created_at,
        comments: item.comments }));

        this.activePage = 'postsIndex'
    },

    showPostDetails(id) {
      this.selectedPost = this.posts.find(post => post.id === id);

      this.comments = this.selectedPost.comments

      this.activePage = 'postDetails'
    },
    
    resetPostDetails(){
      this.selectedPostId = null;

      this.selectedPost = null;
    }
  }
}