class PortfoliorrrProfilesController < ApplicationController
  before_action :authenticate_user!, only: %i[search show]
  before_action :set_project, only: %i[search show]

  def show
    @portfoliorrr_profile_id = params[:id].to_i
    @current_invitation = @project.invitations.find_by(profile_id: @portfoliorrr_profile_id, status: :pending)

    @current_invitation&.validate_expiration_days

    @profile = PortfoliorrrProfile.find(@portfoliorrr_profile_id)
    return redirect_to root_path if @profile.blank?

    @invitation = Invitation.new
  end

  def search
    @query = params[:q]
    @portifoliorrr_profiles = @query ? PortifoliorrrProfile.find(@query) : PortifoliorrrProfile.all
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
