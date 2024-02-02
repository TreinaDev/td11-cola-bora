require 'rails_helper'

describe 'Project API' do
  context 'GET /api/v1/projects' do
    it 'com sucesso' do
      project_owner = create(:user)
      project = create(:project, user: project_owner, title: 'Primeiro Projeto',
                                 description: 'Esse é o primeiro projeto', category: 'Site')
      create(:project, user: project_owner, title: 'Segundo Projeto',
                       description: 'Projeto de edição', category: 'Video')

      create(:project_job_category, project:, job_category_id: 1)
      create(:project_job_category, project:, job_category_id: 2)

      get '/api/v1/projects'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.length).to eq 2
      expect(json_response[0]['id']).to eq 1
      expect(json_response[0]['title']).to eq 'Primeiro Projeto'
      expect(json_response[0]['description']).to eq 'Esse é o primeiro projeto'
      expect(json_response[0]['category']).to eq 'Site'
      expect(json_response[0]['project_job_categories'][0]['job_category_id']).to eq 1
      expect(json_response[0]['project_job_categories'][1]['job_category_id']).to eq 2
      expect(json_response[1]['id']).to eq 2
      expect(json_response[1]['title']).to eq 'Segundo Projeto'
      expect(json_response[1]['description']).to eq 'Projeto de edição'
      expect(json_response[1]['category']).to eq 'Video'
      expect(json_response[1]['project_job_categories'].any?).to eq false
    end

    it 'e não tem nenhum projeto' do
      get '/api/v1/projects'

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['message']).to eq 'Nenhum projeto encontrado.'
    end

    it 'e retorna erro interno' do
      create(:project, title: 'Primeiro Projeto',
                       description: 'Esse é o primeiro projeto', category: 'Site')
      allow(Project).to receive(:all).and_raise(ActiveRecord::ActiveRecordError)

      get '/api/v1/projects'

      expect(response).to have_http_status 500
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response[0]).to eq nil
      expect(json_response['errors']).to include 'Erro interno de servidor.'
    end
  end
end
