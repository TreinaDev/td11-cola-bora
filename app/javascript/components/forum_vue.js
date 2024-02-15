import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      project: {},
      posts: ref([]),
      newPost: {
        title: '',
        body: ''
      },
      errors: window.errors
    }
  },
  
  async mounted() {
    this.loadPosts();
    this.project = { id: window.project.id,
                     title: window.project.title };
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
        const csrfToken = document.querySelector('meta[name="csrf-token"]').getAttribute('content');

        const response = await fetch(`/projects/${this.project.id}/posts`, {
          method: 'POST',
          headers: {
            'Content-Type': 'application/json',
            'X-CSRF-Token': csrfToken
          },
          body: JSON.stringify(this.newPost)
        });

        const data = await response.json()
        console.log(data)
        this.posts.unshift(data)
        this.newPost.title = ''
        this.newPost.body = ''
      } catch (error) {
        console.error('Erro ao enviar o formulário:', error);
      }
    }
  }
}
