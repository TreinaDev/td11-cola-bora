class ForumsController < ApplicationController
  def index
    @project = Project.find(params[:project_id])
    @posts = @project.posts
  end
end
