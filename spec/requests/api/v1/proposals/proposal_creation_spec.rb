require 'rails_helper'

describe 'Criação de requisição de participação em projeto' do
  context '/api/v1/proposals' do
    it 'com sucesso' do
      project = create :project
      params = { proposal: {
        profile_id: 1,
        portfoliorrr_proposal_id: 9,
        project_id: project.id,
        message: 'Gostaria de participar!',
        email: 'proposer@email.com'
      } }

      post(api_v1_proposals_path, params:)

      expect(response).to have_http_status :created
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response['data']['proposal_id']).to eq Proposal.last.id
      expect(Proposal.count).to eq 1
      expect(Proposal.last.profile_id).to eq 1
      expect(Proposal.last.portfoliorrr_proposal_id).to eq 9
      expect(Proposal.last.project).to eq project
      expect(Proposal.last.message).to eq 'Gostaria de participar!'
      expect(Proposal.last.email).to eq 'proposer@email.com'
      expect(Proposal.last.status).to eq 'pending'
    end

    context 'sem sucesso' do
      it 'se usuário já faz parte do projeto' do
        project = create :project
        contributor = create :user, cpf: '795.780.710-00', email: 'contributor@email.com'
        contributor_portfoliorrr_profile_id = 99
        project.user_roles.create! project:, user: contributor, active: true
        params = { proposal: {
          project_id: project.id,
          portfoliorrr_proposal_id: 9,
          profile_id: contributor_portfoliorrr_profile_id,
          email: 'contributor@email.com'
        } }

        post(api_v1_proposals_path, params:)

        expect(Proposal.count).to eq 0
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status :conflict
        expect(json_response['errors']).to eq ['Usuário já faz parte deste projeto']
      end

      it 'se já existe uma solicitação pendente' do
        project = create :project
        profile_id = 123
        create :proposal, project:, profile_id:, status: :pending,
                          email: 'proposer@email.com'
        params = { proposal: {
          project_id: project.id,
          portfoliorrr_proposal_id: 9,
          profile_id:,
          email: 'proposer@email.com'
        } }

        post(api_v1_proposals_path, params:)

        expect(Proposal.count).to eq 1
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status :conflict
        expect(json_response['errors']).to eq ['Usuário já tem solicitação pendente para o projeto']
      end

      it 'se projeto não existe' do
        params = { proposal: {
          profile_id: 1,
          project_id: 999,
          portfoliorrr_proposal_id: 9,
          message: '',
          email: 'proposal@email.com'
        } }

        post(api_v1_proposals_path, params:)

        expect(response).to have_http_status :not_found
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq 'Projeto não encontrado'
      end

      it 'se id de perfil estiver vazio' do
        project = create :project
        params = { proposal: {
          profile_id: '',
          project_id: project.id,
          portfoliorrr_proposal_id: 9,
          message: '',
          email: 'proposal@email.com'
        } }

        post(api_v1_proposals_path, params:)

        expect(response).to have_http_status :conflict
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include 'ID de Perfil não pode ficar em branco'
        expect(json_response['errors']).to include 'ID de Perfil não é um número'
      end

      it 'se ID de Solicitação estiver vazio' do
        project = create :project
        params = { proposal: {
          profile_id: 5,
          project_id: project.id,
          portfoliorrr_proposal_id: '',
          message: '',
          email: 'proposal@email.com'
        } }

        post(api_v1_proposals_path, params:)

        expect(response).to have_http_status :conflict
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include 'ID de Solicitação não pode ficar em branco'
        expect(json_response['errors']).to include 'ID de Solicitação não é um número'
      end

      it 'em caso de erro de servidor' do
        project = create :project
        params = { proposal: {
          profile_id: '1',
          project_id: project.id,
          portfoliorrr_proposal_id: 9,
          message: '',
          email: 'proposal@email.com'
        } }

        allow(Proposal).to receive(:new).and_raise(ActiveRecord::ActiveRecordError)
        post(api_v1_proposals_path, params:)

        expect(response).to have_http_status :internal_server_error
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to eq ['Erro interno de servidor.']
      end
    end
  end
end
