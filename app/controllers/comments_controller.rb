class CommentsController < ApplicationController
  before_action :set_post, only: %i[create]
  before_action :authorize_member, only: %i[create]

  def create
    @comment = @post.comments.build(comment_params)
    @comment.user_role = UserRole.find_by(user: current_user, project: @post.project)

    return render status: :created, json: json_response(@comment) if @comment.save

    render status: :unprocessable_entity, json: @comment.errors.full_messages
  end

  private

  def json_response(comment)
    { id: comment.id, content: comment.content, author: comment.user_role.user.full_name,
      created_at: comment.formatted_date }
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_member
    render status: :unauthorized, json: { errors: t('.unauthorized') } unless @post.project.member?(current_user)
  end

  def set_post
    @post = Post.find(params[:post_id])
  end
end
