class PortfoliorrrProfilesController < ApplicationController
  def show
    @project = Project.find(params[:project_id])
    @portfoliorrr_profile_id = params[:id]
    @current_invitation = @project.invitations.find_by(profile_id: @portfoliorrr_profile_id, status: :pending)

    response = Faraday.get("https://e07813cd-df3d-4023-920b-4037df5a0c31.mock.pstmn.io/profiles/#{@portfoliorrr_profile_id}")
    if response.status == 200
      @profile = JSON.parse(response.body)
      @invitation = Invitation.new
    else
      redirect_to root_path
    end
  end
end
