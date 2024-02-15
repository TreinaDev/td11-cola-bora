class PostsController < ApplicationController
  before_action :set_project
  before_action :check_contributor

  def create
    @post = @project.posts.build(post_params)
    @post.user_role = UserRole.find_by(user: current_user, project: @project)

    render status: :created, json: json_response(@post) if @post.save!
  end

  def update
    @post = Post.find.params(:id)
    if @post.update(post_params)
      redirect_to project_forum_path(@project), notice: t('.success')
    else
      flash.now[:alert] = t('.fail')
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def json_response(post)
    { id: post.id, title: post.title, body: post.body, author: post.user.full_name }
  end

  def set_project
    @project = Project.find(params[:project_id])
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end

  def post_params
    params.require(:post).permit(:title, :body)
  end
end
