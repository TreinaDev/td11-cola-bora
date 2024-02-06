require 'rails_helper'

describe 'Criação de requisição de participação em projeto' do
  context '/api/v1/proposals' do
    it 'com sucesso' do
      project = create :project
      params = { proposal: {
        profile_id: 1,
        project_id: project.id,
        message: 'Gostaria de participar!'
      } }

      post(api_v1_proposals_path, params:)

      expect(response).to have_http_status :created
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response['data']['proposal_id']).to eq Proposal.last.id
      expect(Proposal.count).to eq 1
      expect(Proposal.last.profile_id).to eq 1
      expect(Proposal.last.project).to eq project
      expect(Proposal.last.message).to eq 'Gostaria de participar!'
      expect(Proposal.last.status).to eq 'pending'
    end
  end
end
