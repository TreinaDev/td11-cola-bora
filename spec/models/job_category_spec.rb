require 'rails_helper'

RSpec.describe JobCategory, type: :model do
  context '#all' do
    it 'API retorna todos os resultados' do
      url = 'http://localhost:4000/api/v1/job_categories'
      json = File.read(Rails.root.join('spec/support/json/job_categories.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.all

      expect(job_categories.count).to eq 4
      expect(job_categories[0].name).to eq 'Desenvolvedor'
      expect(job_categories[1].name).to eq 'Administrador'
      expect(job_categories[2].name).to eq 'Designer'
      expect(job_categories[3].name).to eq 'Engenheiro de Software'
    end

    it 'API retorna vazio' do
      url = 'http://localhost:4000/api/v1/job_categories'
      fake_response = double('faraday_response', status: 200, body: '{ "data": [] }', success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.all

      expect(job_categories.count).to eq 0
      expect(job_categories[0]).to eq nil
    end

    it 'API retorna erro interno' do
      url = 'http://localhost:4000/api/v1/job_categories'
      fake_response = double('faraday_response', status: 500, body: '{ "error": ["Erro interno"] }', success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.all

      expect(job_categories.count).to eq 0
      expect(job_categories[0]).to eq nil
    end

    it 'e não consegue se conectar na API' do
      url = 'http://localhost:4000/api/v1/job_categories'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      job_categories = JobCategory.all

      expect(job_categories.count).to eq 0
      expect(job_categories[0]).to eq nil
    end
  end

  context '#find' do
    it 'API retorna resultado' do
      url = 'http://localhost:4000/api/v1/job_categories/2'
      json = File.read(Rails.root.join('spec/support/json/job_category_details_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.find(2)

      expect(job_categories.name).to eq 'Desenvolvedor'
    end

    it 'API retorna que não foi encontrado' do
      url = 'http://localhost:4000/api/v1/job_categories/999'
      fake_response = double('faraday_response', status: 404, body: '{ "errors": ["Perfil não encontrado"] }',
                                                 success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.find(999)

      expect(job_categories).to be_blank
    end

    it 'API retorna erro interno' do
      url = 'http://localhost:4000/api/v1/job_categories/1'
      fake_response = double('faraday_response', status: 500, body: '{ "errors": ["Erro interno de servidor"] }',
                                                 success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      job_categories = JobCategory.find(1)

      expect(job_categories).to be_blank
    end

    it 'e não consegue se conectar com a API' do
      url = 'http://localhost:4000/api/v1/job_categories/1'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      job_categories = JobCategory.find(1)

      expect(job_categories).to be_blank
    end
  end

  context '#fetch_job_categories_by_project' do
    it 'busca categorias de trabalho de um projeto' do
      user = create(:user)
      project = create(:project, user:)
      other_project = create(:project, user:)
      job_categories = [JobCategory.new(id: 1, name: 'Editor de Video'),
                        JobCategory.new(id: 2, name: 'Editor de Imagem'),
                        JobCategory.new(id: 3, name: 'Desenvolvedor')]
      allow(JobCategory).to receive(:find).and_return(job_categories[0], job_categories[1])
      project_job_categories = [create(:project_job_category, project:, job_category_id: 1),
                                create(:project_job_category, project:, job_category_id: 2)]
      create(:project_job_category, project: other_project, job_category_id: 3)

      response = JobCategory.fetch_job_categories_by_project(project_job_categories)

      expect(response[0].name).to eq 'Editor de Video'
      expect(response[1].name).to eq 'Editor de Imagem'
      expect(response.count).to eq 2
    end
  end
end
