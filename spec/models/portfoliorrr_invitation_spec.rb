require 'rails_helper'

RSpec.describe PortfoliorrrInvitation, type: :model do
  context '#post_invitation' do
    it 'com sucesso atualiza o status e o portfoliorrr_invitation_id' do
      json = { data: { id: 3 } }
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation)
      portfoliorrr_invitation = PortfoliorrrInvitation.new(invitation)

      portfoliorrr_invitation.post_invitation

      expect(invitation.reload.portfoliorrr_invitation_id).to eq 3
      expect(invitation.reload.status).to eq 'pending'
    end

    it 'bad request e convite é cancelado' do
      fake_response = double('faraday_response', status: 404, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation)
      portfoliorrr_invitation = PortfoliorrrInvitation.new(invitation)

      portfoliorrr_invitation.post_invitation

      expect(invitation.reload.portfoliorrr_invitation_id).to eq nil
      expect(invitation.reload.status).to eq 'cancelled'
    end

    it 'server error e convite é cancelado' do
      fake_response = double('faraday_response', status: 500, success?: false)
      allow(Faraday).to receive(:post).and_return(fake_response)
      invitation = create(:invitation)
      portfoliorrr_invitation = PortfoliorrrInvitation.new(invitation)

      portfoliorrr_invitation.post_invitation

      expect(invitation.reload.portfoliorrr_invitation_id).to eq nil
      expect(invitation.reload.status).to eq 'cancelled'
    end

    it 'não consegue se conectar com a API' do
      invitation = create(:invitation)
      portfoliorrr_invitation = PortfoliorrrInvitation.new(invitation)

      portfoliorrr_invitation.post_invitation

      expect(invitation.reload.portfoliorrr_invitation_id).to eq nil
      expect(invitation.reload.status).to eq 'cancelled'
    end
  end
end
