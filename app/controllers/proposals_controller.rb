class ProposalsController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    redirect_to root_path, alert: t(:unauthorized) unless @project.leader? current_user

    status = params[:status]

    return @proposals = @project.proposals if status.blank?

    @proposals = @project.proposals.where(status:)
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
