class CommentsController < ApplicationController
  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.build(comment_params)
    @comment.user_role = UserRole.find_by(user: current_user, project: @post.project)

    if @comment.save!
      redirect_to project_forum_path(@post.project), status: :created
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end
end
