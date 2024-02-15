class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_role = UserRole.find_by(user: current_user, project: @post.project)

    render status: :created, json: json_response(@comment) if @comment.save!
  end

  private

  def json_response(comment)
    { id: comment.id, content: comment.content, author: comment.user_role.user.full_name,
      created_at: comment.formatted_date }
  end

  def comment_params
    params.require(:comment).permit(:content)
  end
end
