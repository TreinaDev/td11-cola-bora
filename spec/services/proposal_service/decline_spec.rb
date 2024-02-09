require 'rails_helper'

RSpec.describe ProposalService::Decline do
  context '.send' do
    it 'Altera status da solicitação para recusado se retornar sucesso da API' do
      fake_response = double('faraday_response', status: :no_content, success?: true)
      allow(Faraday).to receive(:patch).and_return(fake_response)
      proposal = create :proposal, status: :processing

      ProposalService::Decline.send proposal

      expect(proposal.reload.status).to eq 'declined'
    end

    context 'Altera status da solicitação para pendente' do
      it 'se não retornar sucesso da API' do
        fake_response = double('faraday_response', success?: false)
        allow(Faraday).to receive(:patch).and_return fake_response
        proposal = create :proposal, status: :processing

        ProposalService::Decline.send proposal

        expect(proposal.reload.status).to eq 'pending'
      end

      it 'se não conseguir conectar com a API' do
        proposal = create :proposal, status: :processing

        ProposalService::Decline.send proposal

        expect(proposal.reload.status).to eq 'pending'
      end
    end

    it 'Não faz nada se o status da solicitação não é processing' do
      proposal = create :proposal, status: :accepted

      ProposalService::Decline.send proposal

      expect(proposal.reload.status).to eq 'accepted'
    end
  end
end
