module Api
  module V1
    class ProposalsController < Api::V1::ApiController
      def create
        project = Project.find(params[:proposal][:project_id])
        proposal = project.proposals.new(
          params.require(:proposal).permit(:profile_id, :message)
        )

        proposal.save
        render json: { data: { proposal_id: proposal.id } }, status: :created
      end
    end
  end
end
