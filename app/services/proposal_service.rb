module ProposalService
  PORTFOLIORRR_BASE_URL = 'http://localhost:4000'.freeze
  PORTFOLIORRR_PROPOSAL_URL = '/api/v1/invitation_request/'.freeze

  class Decline
    def self.send(proposal)
      Faraday.new(
        url: PORTFOLIORRR_BASE_URL,
        headers: { 'Content-Type': 'application/json' }
      ).patch(PORTFOLIORRR_PROPOSAL_URL + proposal.portfoliorrr_proposal_id.to_s)
    end
  end
end
