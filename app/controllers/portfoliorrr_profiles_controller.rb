class PortfoliorrrProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[search show]
  before_action :set_project, only: %i[search show]
  before_action :participant?, only: %i[search show]
  before_action :leader?, only: %i[search show]

  def search
    @query = params[:q]
    @portfoliorrr_profiles = @query ? PortfoliorrrProfile.search(@query) : PortfoliorrrProfile.all
  end

  def show
    @portfoliorrr_profile = PortfoliorrrProfile.find(params['id'])
  end

  private

  def participant?
    redirect_to root_path, alert: t('unauthorized') unless @project.participant?(current_user)
  end

  def leader?
    redirect_to root_path, alert: t('unauthorized') unless @project.leader?(current_user)
  end

  def set_project
    @project = Project.find(params[:project_id])
  end
end