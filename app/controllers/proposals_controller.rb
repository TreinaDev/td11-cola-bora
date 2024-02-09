class ProposalsController < ApplicationController
  before_action :set_proposal, only: %i[decline]
  before_action :set_project, only: %i[index decline]
  before_action :authorize_leader, only: %i[index decline]

  def index
    status = params[:status]
    @max_characters = Proposal::MAXIMUM_MESSAGE_CHARACTERS

    return @proposals = @project.proposals if status.blank?

    @proposals = @project.proposals.where(status:).order(:created_at)
  end

  def decline
    @proposal.processing!
    ProposalService::Decline.send @proposal
    redirect_to project_portfoliorrr_profile_path(@proposal.project_id, @proposal.profile_id),
                notice: t('.processing')
  end

  private

  def set_proposal
    @proposal = Proposal.find(params[:id])
  end

  def set_project
    @project = Project.find_by(id: params[:project_id]) || @proposal.project
  end

  def authorize_leader
    redirect_to root_path, alert: t(:unauthorized) unless @project.leader? current_user
  end
end
