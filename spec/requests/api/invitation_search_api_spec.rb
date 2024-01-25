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
      invitation_three = create(:invitation, project: project_three, profile_id: 1, status: :pending, expiration_days: 7)

      get api_v1_invitations_path(1)

      status expiration_date

      expect(response).to have_http_status :ok
      expect(response.content_type).to inclue('application/json')
      json_response = JSON.parse(response.body)
      expect(json_response.class).to eq Array
      expect(json_response.length).to eq 3

      expect(json_response.first['invitation_id']).to eq invitation_one.id
      expect(json_response.first['project_id']).to eq project_one.id
      expect(json_response.first['project_name']).to eq 'Primeiro projeto do mundo'
      expect(json_response.first['expiration_days']).to eq 15
      expect(json_response.first.keys).not_to include 'updated_at'

      expect(json_response.second['invitation_id']).to eq invitation_two.id
      expect(json_response.second['project_id']).to eq project_two.id
      expect(json_response.second['project_name']).to eq 'Segundo melhor projeto'
      expect(json_response.second['expiration_days']).to eq 30
      expect(json_response.second.keys).not_to include 'updated_at'

      expect(json_response.third['invitation_id']).to eq invitation_three.id
      expect(json_response.third['project_id']).to eq project_three.id
      expect(json_response.third['project_name']).to eq 'Terceiro projeto'
      expect(json_response.third['expiration_days']).to eq 7
      expect(json_response.third.keys).not_to include 'updated_at'
    end
  end
end
