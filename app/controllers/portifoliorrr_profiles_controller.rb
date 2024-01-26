class PortifoliorrrProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[search]
  before_action :set_project, only: %i[search]
  before_action :authorize_user, only: %i[search]

  def search
    @query = params[:q]
    @portifoliorrr_profiles = @query ? PortifoliorrrProfile.find(@query) : PortifoliorrrProfile.all
  end

  private

  def authorize_user
    redirect_to root_path, alert: t('unauthorized') unless @project.leader?(current_user)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end