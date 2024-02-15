require 'rails_helper'

RSpec.describe InvitationService::PortfoliorrrPatch do
  context '.send' do
    it 'verdadeiro quando efetua a requisição e retorna sucesso' do
      fake_response = double('faraday_response', success?: true)
      allow(Faraday).to receive(:patch).and_return(fake_response)
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send invitation, invitation.status

      expect(response).to eq true
    end

    it 'falso quando efetua a requisição e não retorna sucesso' do
      fake_response = double('faraday_response', success?: false)
      allow(Faraday).to receive(:patch).and_return(fake_response)
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send(invitation, invitation.status)

      expect(response).to eq false
    end
  end
end
