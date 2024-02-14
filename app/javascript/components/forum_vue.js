import { ref } from "vue/dist/vue.esm-bundler.js"

export default {
  data() {
    return {
      searchText: '',
      selectedFilter: '',
      project: {},
      posts: [{title: 'teste', body: 'Teste'}],
      newPost: {
        title: '',
        body: ''
      }
    }
  },
  
  async mounted() {
    console.log(this.posts)
    this.posts = await window.posts.map(item => ({ title: item.title,
                                             body: item.body,
                                             author: item.user_name,
                                             date: item.created_at }));
    this.project = { id: window.project.id,
                     title: window.project.title };

                     console.log(this.posts)
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

        location.reload()

        this.newPost.title = '';
        this.newPost.body = '';
      } catch (error) {
        console.error('Erro ao enviar o formulário:', error);
      }
    }
  }
}
