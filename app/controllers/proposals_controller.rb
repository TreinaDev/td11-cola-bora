class ProposalsController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    redirect_to root_path, alert: t(:unauthorized) unless @project.leader? current_user

    status = params[:status]
    @max_characters = Proposal::MAXIMUM_MESSAGE_CHARACTERS

    return @proposals = @project.proposals if status.blank?

    @proposals = @project.proposals.where(status:).order(:created_at)
  end

  def decline
    proposal = Proposal.find(params[:id])
    if proposal.declined!
      redirect_to project_portfoliorrr_profile_path(proposal.project_id, proposal.profile_id),
                  notice: t('.success')
    else
      redirect_to project_portfoliorrr_profile_path(proposal.project_id, proposal.profile_id),
                  notice: t('.fail')
    end
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
