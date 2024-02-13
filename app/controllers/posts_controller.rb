class PostsController < ApplicationController
  def create
    @project = Project.find(params[:project_id])
    @post = @project.posts.build(post_params)
    @post.user_role = UserRole.find_by(user: current_user, project: @project)

    if @post.save!
      redirect_to project_forum_path(@project), status: :created
    else
      redirect_to project_forum_path(@project), status: :unprocessable_entity
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
