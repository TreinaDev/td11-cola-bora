module Api
  module V1
    class InvitationsController < Api::V1::ApiController
      def index
        @invitations = Invitation.pending.where(profile_id: params[:id])
        @invitations_array = []
        render status: :ok, json: set_json
      end

      private

      def set_json
        @invitations.each do |invitation|
          inv = {}
          inv['invitation_id'] = invitation.id
          inv['expiration_days'] = invitation.expiration_days
          inv['project_id'] = invitation.project.id
          inv['project_title'] = invitation.project.title
          inv['created_at'] = invitation.created_at
          @invitations_array << inv
        end

        @invitations_array.as_json
      end
    end
  end
end
