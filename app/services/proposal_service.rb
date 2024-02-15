module ProposalService
  URL = Rails.configuration.portfoliorrr_api[:base_url] +
        Rails.configuration.portfoliorrr_api[:proposal_endpoint]

  class Decline
    def self.send(proposal)
      return unless proposal.processing?

      url = URL + proposal.portfoliorrr_proposal_id.to_s
      header = { 'Content-Type': 'application/json' }

      return proposal.declined! if Faraday.patch(url, header).success?

      proposal.pending!
    rescue Faraday::ConnectionFailed
      proposal.pending!
    end
  end
end
