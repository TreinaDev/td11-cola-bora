module ProposalService
  PORTFOLIORRR_BASE_URL = 'http://localhost:4000'.freeze
  PORTFOLIORRR_PROPOSAL_URL = '/api/v1/invitation_request/'.freeze

  class ProposalDecline
    def self.send(proposal)
      response = conn.patch(PORTFOLIORRR_PROPOSAL_URL + proposal.id.to_s) do |req|
        req.body = { invitation_request: {
          profile_id: proposal.profile_id,
          email: proposal.email
        } }

        return true if response.success?
      end
    end

    class << self
      private

      def conn
        Faraday.new(
          url: PORTFOLIORRR_BASE_URL,
          headers: { 'Content-Type': 'application/json' }
        )
      end
    end
  end
end
