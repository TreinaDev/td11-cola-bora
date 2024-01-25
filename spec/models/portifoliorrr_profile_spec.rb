require 'rails_helper'

RSpec.describe PortifoliorrrProfile, type: :model do
  context '#all' do
    it 'API retorna todos os resultados' do
      url = 'http://localhost:8000/api/v1/users'
      json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portifliorrr_profiles = PortifoliorrrProfile.all

      expect(portifliorrr_profiles.count).to eq 3
      expect(portifliorrr_profiles[0].name).to eq 'Lucas'
      expect(portifliorrr_profiles[0].job_category).to eq 'Desenvolvedor'
      expect(portifliorrr_profiles[1].name).to eq 'Mateus'
      expect(portifliorrr_profiles[1].job_category).to eq 'Designer'
      expect(portifliorrr_profiles[2].name).to eq 'Rodolfo'
      expect(portifliorrr_profiles[2].job_category).to eq 'Editor de Video'
    end

    it 'API retorna vazio' do
      url = 'http://localhost:8000/api/v1/users'
      fake_response = double('faraday_response', status: 200, body: '{ "data": [] }', success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portifliorrr_profiles = PortifoliorrrProfile.all

      expect(portifliorrr_profiles.count).to eq 0
      expect(portifliorrr_profiles[0]).to eq nil
    end

    it 'API retorna erro interno' do
      url = 'http://localhost:8000/api/v1/users'
      fake_response = double('faraday_response', status: 500, body: '{ "error": ["Erro interno"] }', success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portifliorrr_profiles = PortifoliorrrProfile.all

      expect(portifliorrr_profiles.count).to eq 0
      expect(portifliorrr_profiles[0]).to eq nil
    end

    it 'e não consegue se conectar na API' do
      url = 'http://localhost:8000/api/v1/users'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      portifliorrr_profiles = PortifoliorrrProfile.all

      expect(portifliorrr_profiles.count).to eq 0
      expect(portifliorrr_profiles[0]).to eq nil
    end
  end

  context '#find' do
    it 'e retorna os resultados filtrados' do
      url = 'http://localhost:8000/api/v1/users?search=video'
      json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data_filtered.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      portifoliorrr_profiles = PortifoliorrrProfile.search('video')

      expect(portifoliorrr_profiles.count).to eq 1
      expect(portifoliorrr_profiles[0].name).to eq 'Rodolfo'
      expect(portifoliorrr_profiles[0].job_category).to eq 'Editor de Video'
    end
  end
end
