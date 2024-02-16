module Api
  module V1
    class ProposalsController < Api::V1::ApiController
      before_action :set_project, only: %i[create]

      def create
        @proposal = @project.proposals.new(proposal_params.except(:invitation_request_id))
        @proposal.portfoliorrr_proposal_id = proposal_params[:invitation_request_id]

        return success_result if @proposal.save

        render json: { errors: @proposal.errors.full_messages }, status: :conflict
      end

      def update
        proposal = Proposal.find(params[:id])

        return render status: :conflict, json: { errors: I18n.t('proposal.conflict') } unless proposal.pending?

        proposal.cancelled!
        head :no_content
      end

      private

      def success_result
        ProposalMailer.with(proposal: @proposal).notify_leader.deliver
        render json: { data: { proposal_id: @proposal.id } }, status: :created
      end

      def set_project
        @project = Project.find(proposal_params[:project_id])
      rescue ActiveRecord::RecordNotFound
        render json: { errors: I18n.t('.missing_project') }, status: :not_found
      end

      def proposal_params
        params.require(:proposal).permit(:profile_id, :invitation_request_id, :message,
                                         :email, :project_id)
      end
    end
  end
end
