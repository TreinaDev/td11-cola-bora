require 'rails_helper'

describe 'Invitation decline API' do
  context 'PATCH /api/v1/invitations/:id' do
    it 'sucesso e status muda para declined' do
      invitation = create(:invitation, status: :pending)

      patch api_v1_invitation_path(invitation.id)

      expect(response).to have_http_status :ok
      expect(invitation.reload.status).to eq 'declined'
    end

    it 'falha convite não existe' do
      invitation = create(:invitation, status: :pending)

      patch api_v1_invitation_path(9)

      expect(response).to have_http_status :not_found
      expect(invitation.reload.status).to eq 'pending'
    end

    it 'convite não está pendente' do
      invitation = create(:invitation, status: :cancelled)

      patch api_v1_invitation_path(invitation.id)

      expect(response).to have_http_status :conflict
      expect(invitation.reload.status).to eq 'cancelled'
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to include 'Não é possível alterar convite que não está pendente.'
    end

    it 'retorna erro interno do servidor' do
      invitation = create(:invitation, status: :pending)
      allow(Invitation).to receive(:find).and_raise(ActiveRecord::ActiveRecordError)

      patch api_v1_invitation_path(1)

      expect(response).to have_http_status :internal_server_error
      expect(invitation.reload.status).to eq 'pending'
    end
  end
end
