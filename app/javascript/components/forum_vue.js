

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      project: {},
      posts: [],
      newPost: {
        title: '',
        body: ''
      },
      errors: []
    }
  },
  
  async mounted() {
    this.loadPosts();
    this.project = { id: window.project.id,
                     title: window.project.title };
    this.errors = []
  },

  computed: {
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
        date: item.date }));

        this.activePage = 'postsIndex'
       
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
        if (response.ok) {
          this.filteredPosts.unshift(data);
          this.newPost.title = ''
          this.newPost.body = ''
        } else {
          this.errors = data.errors;
        }
      } catch (error) {
        console.error('Erro ao enviar o formulário:', error);
      }
    },
    async deletePost(item) {
    
      const response = await fetch(`/api/v1/projects/${this.project.id}/posts/${item.id}`, {
        method: 'DELETE',
        headers: {
          'Content-Type': 'application/json'
        }
      });
    
      if (response.ok) {
        const index = this.filteredPosts.findIndex(post => post.id === item.id);
        
        if (index !== -1) {
          this.filteredPosts.splice(index, 1);
        }
        console.log(this.filteredPosts)

      } else {
        console.error('Erro ao excluir post:', response.statusText);
      }
    }
  }
}
