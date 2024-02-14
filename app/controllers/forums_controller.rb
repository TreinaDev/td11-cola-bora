class ForumsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @posts = @project.posts.order(created_at: :desc)
  end
end
