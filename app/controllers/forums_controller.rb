class ForumsController < ApplicationController
  before_action :set_project
  before_action :check_contributor
  def index
    @posts = @project.posts.order(created_at: :desc)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end

  def check_contributor
    redirect_to root_path, alert: t('.not_contributor') unless @project.member?(current_user)
  end
end
