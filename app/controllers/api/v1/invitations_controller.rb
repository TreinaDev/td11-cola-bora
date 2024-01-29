module Api
  module V1
    class InvitationsController < Api::V1::ApiController
      def index
        @invitations = Invitation.pending.where(profile_id: params[:id])
        render status: :ok, json: set_json
      end

      private

      def set_json
        @invitations.map do |invitation|
          {
            invitation_id: invitation.id,
            expiration_days: invitation.expiration_days,
            project_id: invitation.project.id,
            project_title: invitation.project.title,
            created_at: invitation.created_at.to_s
          }
        end
      end
    end
  end
end
