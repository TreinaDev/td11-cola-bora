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

    context 'sem sucesso' do
      it 'se usuário já faz parte do projeto' do
        project = create :project
        contributor = create :user, cpf: '795.780.710-00', email: 'contributor@email.com'
        contributor_portfoliorrr_profile_id = 99
        create :invitation, status: :accepted,
                            project:,
                            profile_id: contributor_portfoliorrr_profile_id,
                            profile_email: 'contributor@email.com'
        project.user_roles.create! project:, user: contributor, active: true
        params = { proposal: {
          project_id: project.id,
          profile_id: contributor_portfoliorrr_profile_id
        } }

        post(api_v1_proposals_path, params:)

        expect(Proposal.count).to eq 0
        json_response = JSON.parse(response.body)
        expect(response).to have_http_status :bad_request
        expect(json_response['errors']).to eq ['Usuário já faz parte deste projeto']
      end

      it 'se já existe uma solicitação pendente'

      it 'se projeto não existe' do
        params = { proposal: {
          profile_id: 1,
          project_id: 999,
          message: ''
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
          message: ''
        } }

        post(api_v1_proposals_path, params:)

        expect(response).to have_http_status :bad_request
        json_response = JSON.parse(response.body)
        expect(json_response['errors']).to include 'ID de Perfil não pode ficar em branco'
        expect(json_response['errors']).to include 'ID de Perfil não é um número'
      end

      it 'em caso de erro de servidor' do
        project = create :project
        params = { proposal: {
          profile_id: '1',
          project_id: project.id,
          message: ''
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
