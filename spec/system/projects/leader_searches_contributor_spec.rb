require 'rails_helper'

describe 'Líder de projeto pesquisa por colaboradores' do
  it 'e deve estar autenticado' do
    project = create :project

    visit search_project_portifoliorrr_profiles_path project

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  context 'e não pode ser contribuidor' do
    it 'para acessar a página' do
      project = create :project
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      create :user_role, user:, project:, role: :contributor

      login_as user
      visit search_project_portifoliorrr_profiles_path project

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem acesso a esse recurso'
    end

    it 'para ver o botão' do
      project = create :project
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      create :user_role, user:, project:, role: :contributor

      login_as user
      visit project_path project

      expect(page).not_to have_link 'Procurar usuários'
    end
  end

  context 'e não pode ser administrador' do
    it 'para acessar a página' do
      project = create :project
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      create :user_role, user:, project:, role: :admin

      login_as user
      visit search_project_portifoliorrr_profiles_path project

      expect(current_path).to eq root_path
      expect(page).to have_content 'Você não tem acesso a esse recurso'
    end

    it 'para ver o botão' do
      project = create :project
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      create :user_role, user:, project:, role: :admin

      login_as user
      visit project_path project

      expect(page).not_to have_link 'Procurar usuários'
    end
  end

  it 'e não há colaboradores a serem exibidos' do
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    project = create(:project, user:)
    project.user_roles.find_by(user:).update(role: :leader)
    url = 'http://localhost:8000/api/v1/users'
    fake_response = double('faraday_response', status: 200, body: '{ "data": [] }', success?: true)
    allow(Faraday).to receive(:get).with(url).and_return(fake_response)

    login_as user
    visit search_project_portifoliorrr_profiles_path project

    expect(page).to have_content 'Não há usuários a serem exibidos.'
  end

  context 'com sucesso a partir da home' do
    it 'buscando por todos' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      url = 'http://localhost:8000/api/v1/users'
      json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      login_as user
      visit root_path
      click_on 'Projetos'
      click_on 'Projeto Top'
      click_on 'Procurar usuários'

      expect(current_path).to eq search_project_portifoliorrr_profiles_path project
      expect(page).not_to have_content 'Não há usuários a serem exibidos.'
      expect(page).to have_content 'Usuários disponíveis'
      expect(page).to have_content 'Lucas'
      expect(page).to have_content 'Desenvolvedor'
      expect(page).to have_content 'Mateus'
      expect(page).to have_content 'Designer'
      expect(page).to have_content 'Rodolfo'
      expect(page).to have_content 'Editor de Video'
      expect(page).to have_selector('table tbody tr', count: 3)
    end

    it 'buscando por termo' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)
      url = 'http://localhost:8000/api/v1/users'
      json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)
      url = 'http://localhost:8000/api/v1/users?search=video'
      json = File.read(Rails.root.join('spec/support/portifoliorrr_profiles_data_filtered.json'))
      fake_response = double('faraday_response', status: 200, body: json, success?: true)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      login_as user
      visit search_project_portifoliorrr_profiles_path project
      fill_in 'Busca:', with: 'video'
      click_on 'Buscar'

      expect(current_path).to eq search_project_portifoliorrr_profiles_path project
      expect(page).to have_content 'Resultados para: video'
      expect(page).not_to have_content 'Lucas'
      expect(page).not_to have_content 'Desenvolvedor'
      expect(page).not_to have_content 'Mateus'
      expect(page).not_to have_content 'Designer'
      expect(page).to have_content 'Rodolfo'
      expect(page).to have_content 'Editor de Video'
    end

    it 'e retorna erro interno' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)
      url = 'http://localhost:8000/api/v1/users'
      fake_response = double('faraday_response', status: 500, body: '{ "error": ["Erro interno"] }', success?: false)
      allow(Faraday).to receive(:get).with(url).and_return(fake_response)

      login_as user
      visit search_project_portifoliorrr_profiles_path project

      expect(page).to have_content 'Não há usuários a serem exibidos.'
    end

    it 'e não consegue se conectar com a API' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)
      url = 'http://localhost:8000/api/v1/users'
      allow(Faraday).to receive(:get).with(url).and_raise(Faraday::ConnectionFailed)

      login_as user
      visit search_project_portifoliorrr_profiles_path project

      expect(page).to have_content 'Não há usuários a serem exibidos.'
    end
  end
end
