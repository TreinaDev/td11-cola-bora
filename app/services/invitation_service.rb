module InvitationService
  URL = Rails.configuration.portfoliorrr_api[:base_url] +
        Rails.configuration.portfoliorrr_api[:invitation_endpoint]

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
        { invitation: {
          profile_id: @invitation.profile_id,
          project_id: @invitation.project.id,
          project_title: @invitation.project.title,
          project_description: @invitation.project.description,
          project_category: @invitation.project.category,
          colabora_invitation_id: @invitation.id,
          message: @invitation.message,
          expiration_date: @invitation.expiration_date
        } }
      end

      def post_connection
        headers = { 'Content-Type': 'application/json' }

        @response = Faraday.post(URL, set_json.to_json, headers)
      end

      def post_success
        response_body = JSON.parse(@response.body, symbolize_names: true)
        @invitation.portfoliorrr_invitation_id = response_body[:data][:invitation_id]
        @invitation.pending!
        @invitation.accept_proposal
        @invitation.save
      end

      def post_fail
        false if @invitation.delete
      end
    end
  end

  class PortfoliorrrPatch
    def self.send(invitation, status)
      headers = { 'Content-Type': 'application/json' }
      json = { status: }

      url = URL + invitation.id.to_s
      response = Faraday.patch(url, json.to_json, headers)

      return true if response.success?

      false
    rescue Faraday::ConnectionFailed
      false
    end
  end
end
