class ProposalsController < ApplicationController
  before_action :set_project, only: %i[index]

  def index
    @proposals = @project.proposals.pending
  end

  private

  def set_project
    @project = Project.find(params[:project_id])
  end
end
