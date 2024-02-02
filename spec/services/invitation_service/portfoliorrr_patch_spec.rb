require 'rails_helper'

RSpec.describe InvitationService::PortfoliorrrPatch do
  context '.send' do
    it 'verdadeiro quando efetua a requisição e mantém status cancelado' do
      fake_response = double('faraday_response', status: 200, success?: true)
      allow(Faraday).to receive(:patch).and_return(fake_response)
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send(invitation, invitation.status)

      expect(response).to eq true
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'cancelled'
    end

    it 'falso quando acontece bad request e mantém status cancelado' do
      fake_response = double('faraday_response', status: 404, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send(invitation, invitation.status)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'cancelled'
    end

    it 'falso quando acontece server error e mantém status cancelado' do
      fake_response = double('faraday_response', status: 500, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send(invitation, invitation.status)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'cancelled'
    end

    it 'falso quando não consegue se conectar com a API e mantém status cancelado' do
      invitation = create(:invitation, portfoliorrr_invitation_id: 1, status: :cancelled)

      response = InvitationService::PortfoliorrrPatch.send(invitation, invitation.status)

      expect(response).to eq false
      expect(Invitation.count).to eq 1
      expect(invitation.reload.status).to eq 'cancelled'
    end
  end
end
