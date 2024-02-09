module ProposalService
  PORTFOLIORRR_BASE_URL = 'http://localhost:4000'.freeze
  PORTFOLIORRR_PROPOSAL_URL = '/api/v1/invitation_request/'.freeze

  class Decline
    def self.send(proposal)
      return unless proposal.processing?

      url = PORTFOLIORRR_BASE_URL + PORTFOLIORRR_PROPOSAL_URL + proposal.portfoliorrr_proposal_id.to_s
      header = { 'Content-Type': 'application/json' }

      return proposal.declined! if Faraday.patch(url, header).success?

      proposal.pending!
    rescue Faraday::ConnectionFailed
      proposal.pending!
    end
  end
end
