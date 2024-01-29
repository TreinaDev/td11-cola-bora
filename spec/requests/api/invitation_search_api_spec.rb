require 'rails_helper'

describe 'Invitation search API' do
  context 'GET /api/v1/invitations/1' do
    it 'success' do
      user_one = create(:user, cpf: '24822096092')
      user_two = create(:user, cpf: '38912010018')

      project_one = create(:project, title: 'Primeiro projeto do mundo')
      project_two = create(:project, title: 'Segundo melhor projeto', user: user_one)
      project_three = create(:project, title: 'Terceiro projeto', user: user_two)

      invitation_one = create(:invitation, project: project_one, profile_id: 1, status: :pending, expiration_days: 15)
      invitation_two = create(:invitation, project: project_two, profile_id: 1, status: :pending, expiration_days: 30)
      create(:invitation, project: project_three, profile_id: 1, status: :accepted)
      create(:invitation, project: project_three, profile_id: 15, status: :pending)

      get api_v1_invitations_path(params: { id: 1 })

      expect(response).to have_http_status :ok
      expect(response.content_type).to include('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 2

      expect(json_response.first['invitation_id']).to eq invitation_one.id
      expect(json_response.first['project_id']).to eq project_one.id
      expect(json_response.first['project_title']).to eq 'Primeiro projeto do mundo'
      expect(json_response.first['expiration_days']).to eq 15
      expect(json_response.first.keys).not_to include 'updated_at'

      expect(json_response.second['invitation_id']).to eq invitation_two.id
      expect(json_response.second['project_id']).to eq project_two.id
      expect(json_response.second['project_title']).to eq 'Segundo melhor projeto'
      expect(json_response.second['expiration_days']).to eq 30
      expect(json_response.second.keys).not_to include 'updated_at'
    end

    it 'retorna vazio quando não existem convites para o usuário' do
      get api_v1_invitations_path(params: { id: 1 })

      expect(response).to have_http_status :ok
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response).to eq []
    end

    it 'falha quando ocorre erro interno' do
      allow(Invitation).to receive(:pending).and_raise(ActiveRecord::QueryCanceled)

      get api_v1_invitations_path(params: { id: 1 })

      expect(response).to have_http_status(:internal_server_error)
    end
  end
end
