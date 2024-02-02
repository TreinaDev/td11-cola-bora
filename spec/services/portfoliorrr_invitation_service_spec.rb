require 'rails_helper'

RSpec.describe PortfoliorrrInvitationService do
  context '#post_invitation' do
    it 'sucesso atualiza o status e o portfoliorrr_invitation_id' do
      json = { data: { id: 3 } }
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation)

      response = PortfoliorrrInvitationService.send(invitation)

      expect(response).to eq true
      expect(Invitation.count).to eq 1
      expect(invitation.reload.portfoliorrr_invitation_id).to eq 3
      expect(invitation.reload.status).to eq 'pending'
    end

    context 'convite é deletado' do
      it 'se acontecer bad request' do
        fake_response = double('faraday_response', status: 404, success?: false)
        allow(Faraday).to receive(:post).and_return(fake_response)
        invitation = create(:invitation)

        response = PortfoliorrrInvitationService.send(invitation)

        expect(response).to eq false
        expect(Invitation.count).to eq 0
      end

      it 'se acontecer server error' do
        fake_response = double('faraday_response', status: 500, success?: false)
        allow(Faraday).to receive(:post).and_return(fake_response)
        invitation = create(:invitation)

        response = PortfoliorrrInvitationService.send(invitation)

        expect(response).to eq false
        expect(Invitation.count).to eq 0
      end

      it 'se não conseguir se conectar com a API' do
        invitation = create(:invitation)

        response = PortfoliorrrInvitationService.send(invitation)

        expect(response).to eq false
        expect(Invitation.count).to eq 0
      end
    end
  end
end
