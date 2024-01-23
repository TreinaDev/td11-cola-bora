class ContributorsController < ApplicationController
  before_action :authenticate_user!, only: %i[search]
  before_action :set_project, only: %i[search]
  before_action :authorize_user, only: %i[search]

  def search
    @contributors = params[:q] ? Contributor.find(params[:q]) : Contributor.all
  end

  private

  def authorize_user
    redirect_to root_path, alert: t('unauthorized') unless @project.is_leader?(current_user)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
