module InvitationService
  class PortfoliorrrPost
    def self.send(invitation)
      @invitation = invitation
      post_connection

      return post_fail unless @response.success?

      post_success
    rescue Faraday::ConnectionFailed
      post_fail
    end

    class << self
      private

      def set_json
        { data: { invitation: {
          profile_id: @invitation.profile_id,
          project_title: @invitation.project.title,
          project_description: @invitation.project.description,
          project_category: @invitation.project.category,
          colabora_invitation_id: @invitation.id,
          message: @invitation.message,
          expiration_date: @invitation.expiration_date
        } } }
      end

      def post_connection
        headers = { 'Content-Type': 'application/json' }
        url = 'http://localhost:8000/invitations'

        @response = Faraday.post(url, set_json, headers)
      end

      def post_success
        @invitation.portfoliorrr_invitation_id = @response.body[:data][:id]
        @invitation.pending!
        @invitation.save
      end

      def post_fail
        false if @invitation.delete
      end
    end
  end
end
