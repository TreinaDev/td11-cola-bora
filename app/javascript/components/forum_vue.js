export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      selectedPost: '',
      project: {},
      posts: [],
      newPost: {
        title: '',
        body: ''
      },
      comments: [],
      activePage: 'postsIndex',
      newComment: {
        content: ''
      },
      errorMessages: '',
      errors: []
    }
  },

  async mounted() {
    this.loadPosts();
    this.project = { id: window.project.id,
                     title: window.project.title };
    this.errors = []

    console.log(this.activePage)
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
    loadPosts(){
      this.posts = window.posts.map(item => ({ id: item.id,
        title: item.title,
        body: item.body,
        author: item.author,
        date: item.date,
        comments: item.comments }));

      this.activePage = 'postsIndex'
    },

    showPostDetails(id) {
      this.selectedPost = this.posts.find(post => post.id === id);

      this.comments = this.selectedPost.comments

      this.activePage = 'postDetails'
    },

    async createComment() {
      this.errorMessages = ''

      const response = await fetch(`/api/v1/posts/${this.selectedPost.id}/comments`, {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json'
        },
        body: JSON.stringify({ comment: this.newComment })
      })

      const data = await response.json()
      console.log(data.errors)

      if (!response.ok) {
        return this.errorMessages = data.errors
      } 

      this.comments.push(data)

      this.newComment = {
        content: ''
      }
    },

    async submitForm() {
      try { 
        const response = await fetch(`/api/v1/projects/${this.project.id}/posts`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json'
          },
          body: JSON.stringify(this.newPost)
        });

        const data = await response.json()

        console.log(data)

        if (response.ok) {
          this.posts.unshift(data);
          this.newPost.title = ''
          this.newPost.body = ''
        } else {
          this.errors = data.errors;
        }
      } catch (error) {
        console.error('Erro ao enviar o formulário:', error);
      }
    }
  }
}