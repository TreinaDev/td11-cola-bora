require 'rails_helper'

describe 'PATCH /api/v1/proposals/:id' do
  it 'muda status da solicitação para cancelled' do
    proposal = create :proposal, status: :pending

    patch api_v1_proposal_path proposal

    expect(response).to have_http_status :no_content
    expect(proposal.reload.cancelled?).to be true
  end

  it 'retorna not_found se a solicitação não existe' do
    patch api_v1_proposal_path 999

    expect(response).to have_http_status :not_found
    json_response = JSON.parse(response.body)
    expect(json_response['errors']).to eq ['Erro, não encontrado.']
  end

  it 'retorna internal_server_error em caso de um erro interno' do
    proposal = create :proposal, status: :pending

    allow(Proposal).to receive(:find).and_raise ActiveRecord::ActiveRecordError
    patch api_v1_proposal_path proposal

    expect(response).to have_http_status :internal_server_error
    json_response = JSON.parse(response.body)
    expect(json_response['errors']).to eq ['Erro interno de servidor.']
  end

  context 'retorna conflict se o status da solicitação é' do
    it 'processing' do
      proposal = create :proposal, status: :processing

      patch api_v1_proposal_path proposal

      expect(response).to have_http_status :conflict
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to eq 'Essa solicitação não está pendente'
      expect(proposal.reload.status).not_to eq 'cancelled'
      expect(proposal.status).to eq 'processing'
    end

    it 'accepted' do
      proposal = create :proposal, status: :accepted

      patch api_v1_proposal_path proposal

      expect(response).to have_http_status :conflict
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to eq 'Essa solicitação não está pendente'
      expect(proposal.reload.status).not_to eq 'cancelled'
      expect(proposal.status).to eq 'accepted'
    end

    it 'declined' do
      proposal = create :proposal, status: :declined

      patch api_v1_proposal_path proposal

      expect(response).to have_http_status :conflict
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['errors']).to eq 'Essa solicitação não está pendente'
      expect(proposal.reload.status).not_to eq 'cancelled'
      expect(proposal.status).to eq 'declined'
    end
  end
end
