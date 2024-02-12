require 'rails_helper'

RSpec.describe PortfoliorrrProfile, type: :model do
  context '#all' do
    it 'API retorna todos os resultados' do
      url = 'http://localhost:4000/api/v1/users'
      json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profiles_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfliorrr_profiles = PortfoliorrrProfile.all

      expect(portfliorrr_profiles.count).to eq 3
      expect(portfliorrr_profiles[0].name).to eq 'Lucas'
      expect(portfliorrr_profiles[0].job_categories[0].name).to eq 'Desenvolvedor'
      expect(portfliorrr_profiles[1].name).to eq 'Mateus'
      expect(portfliorrr_profiles[1].job_categories[0].name).to eq 'Designer'
      expect(portfliorrr_profiles[2].name).to eq 'Rodolfo'
      expect(portfliorrr_profiles[2].job_categories[0].name).to eq 'Editor de Video'
    end

    it 'API retorna vazio' do
      url = 'http://localhost:4000/api/v1/users'
      fake_response = double('faraday_response', status: 200, body: '{ "data": [] }', success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfliorrr_profiles = PortfoliorrrProfile.all

      expect(portfliorrr_profiles.count).to eq 0
      expect(portfliorrr_profiles[0]).to eq nil
    end

    it 'API retorna erro interno' do
      url = 'http://localhost:4000/api/v1/users'
      fake_response = double('faraday_response', status: 500, body: '{ "error": ["Erro interno"] }', success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfliorrr_profiles = PortfoliorrrProfile.all

      expect(portfliorrr_profiles.count).to eq 0
      expect(portfliorrr_profiles[0]).to eq nil
    end

    it 'e não consegue se conectar na API' do
      url = 'http://localhost:4000/api/v1/users'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      portfliorrr_profiles = PortfoliorrrProfile.all

      expect(portfliorrr_profiles.count).to eq 0
      expect(portfliorrr_profiles[0]).to eq nil
    end
  end

  context '#search' do
    it 'e retorna os resultados filtrados' do
      url = 'http://localhost:4000/api/v1/users?search=video'
      json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profiles_data_filtered.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfoliorrr_profiles = PortfoliorrrProfile.search('video')

      expect(portfoliorrr_profiles.count).to eq 1
      expect(portfoliorrr_profiles[0].name).to eq 'Rodolfo'
      expect(portfoliorrr_profiles[0].job_categories[0].name).to eq 'Editor de Video'
    end
  end

  context '#find' do
    it 'API retorna resultado' do
      url = 'http://localhost:4000/api/v1/users/3'
      json = File.read(Rails.root.join('spec/support/json/portfoliorrr_profile_details_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfoliorrr_profile = PortfoliorrrProfile.find(3)

      expect(portfoliorrr_profile.name).to eq 'Rodolfo'
      expect(portfoliorrr_profile.email).to eq 'rodolfo@email.com'
      expect(portfoliorrr_profile.job_categories[0].name).to eq 'Editor de Video'
      expect(portfoliorrr_profile.job_categories[0].description).to eq 'Canal do Youtube'
      expect(portfoliorrr_profile.cover_letter).to eq 'Sou editor de vídeos em um canal do Youtube.'
    end

    it 'API retorna que não foi encontrado' do
      url = 'http://localhost:4000/api/v1/users/999'
      fake_response = double('faraday_response', status: 404, body: '{ "errors": ["Perfil não encontrado"] }',
                                                 success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfoliorrr_profile = PortfoliorrrProfile.find(999)

      expect(portfoliorrr_profile).to be_blank
    end

    it 'API retorna erro interno' do
      url = 'http://localhost:4000/api/v1/users/1'
      fake_response = double('faraday_response', status: 500, body: '{ "errors": ["Erro interno de servidor"] }',
                                                 success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portfoliorrr_profile = PortfoliorrrProfile.find(1)

      expect(portfoliorrr_profile).to be_blank
    end

    it 'e não consegue se conectar com a API' do
      url = 'http://localhost:4000/api/v1/users/1'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      portfoliorrr_profile = PortfoliorrrProfile.find(1)

      expect(portfoliorrr_profile).to be_blank
    end
  end
end
