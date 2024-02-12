module Api
  module V1
    class ProposalsController < Api::V1::ApiController
      before_action :set_project, only: %i[create]

      def create
        proposal = @project.proposals.new(proposal_params)

        return render json: { data: { proposal_id: proposal.id } }, status: :created if proposal.save

        render json: { errors: proposal.errors.full_messages }, status: :conflict
      end

      private

      def set_project
        @project = Project.find(params[:proposal][:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: I18n.t('.missing_project') }, status: :not_found
      end

      def proposal_params
        params.require(:proposal).permit(:profile_id, :portfoliorrr_proposal_id, :message, :email)
      end
    end
  end
end
