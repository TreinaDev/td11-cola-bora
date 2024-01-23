class CollaboratorsController < ApplicationController
  before_action :authenticate_user!, only: %i[search]
  before_action :set_project, only: %i[search]
  before_action :authorize_user, only: %i[search]

  def search; end

  private

  def authorize_user
    is_leader = @project.user_roles.find_by(user: current_user).leader?
    redirect_to root_path, alert: t('unauthorized') unless is_leader
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end
