module Api
  module V1
    class PostsController < Api::V1::ApiController
      before_action :set_project
      before_action :check_contributor

      def create
        @post = @project.posts.build(post_params)
        @post.user_role = UserRole.find_by(user: current_user, project: @project)

        return render status: :created, json: json_response(@post) if @post.save

        render json: { errors: @post.errors.full_messages }, status: :conflict
      end

      private

      def json_response(post)
        { id: post.id, title: post.title, body: post.body, author: post.user.full_name,
          date: I18n.t('posts.posted_now') }
      end

      def set_project
        @project = Project.find(params[:project_id])
      end

      def check_contributor
        return if @project.member?(current_user)

        response = { error: I18n.t('posts.no_permission') }

        render status: :forbidden, json: response
      end

      def post_params
        params.require(:post).permit(:title, :body)
      end
    end
  end
end
