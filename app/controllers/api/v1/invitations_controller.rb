module Api
  module V1
    class InvitationsController < Api::V1::ApiController
      def index
        @invitations = Invitation.pending.where(profile_id: params[:profile_id])
        render status: :ok, json: set_json
      end

      def update
        @invitation = Invitation.find(params[:id])
        return render status: :conflict, json: { message: [I18n.t('invitation.conflict')] } unless @invitation.pending?

        @invitation.declined!
        render status: :ok, json: {}
      end

      private

      def set_json
        @invitations.map do |invitation|
          {
            invitation_id: invitation.id,
            expiration_date: invitation.expiration_date,
            project_id: invitation.project.id,
            project_title: invitation.project.title,
            message: invitation.message
          }
        end
      end
    end
  end
end
