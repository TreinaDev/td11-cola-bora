class PortfoliorrrProfilesController < ApplicationController
  def show
    @projects = current_user.projects
    id = params[:id]
    response = Faraday.get("http://localhost:3001/api/v1/profiles/#{id}")
    if response.status == 200
      @profile = JSON.parse(response.body)
      @invitation = Invitation.new
    else
      redirect_to root_path, notice: 'Não foi possível enviar o convite'
    end
  end
end
