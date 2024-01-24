class PortfoliorrrProfilesController < ApplicationController
  def show
    @projects = current_user.projects
    id = params[:id]
    response = Faraday.get("https://e07813cd-df3d-4023-920b-4037df5a0c31.mock.pstmn.io/profiles/#{id}")
    if response.status == 200
      @profile = JSON.parse(response.body)
      @invitation = Invitation.new
    else
      redirect_to root_path
    end
  end
end
