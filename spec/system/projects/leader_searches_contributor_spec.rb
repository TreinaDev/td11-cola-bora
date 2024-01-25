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
    allow(PortifoliorrrProfile).to receive(:all).and_return([])

    login_as user
    visit search_project_portifoliorrr_profiles_path project

    expect(page).to have_content 'Não há usuários a serem exibidos.'
  end

  context 'com sucesso a partir da home' do
    it 'buscando por todos' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      lucas_profile = PortifoliorrrProfile.new id: 1, name: 'Lucas', job_category: 'Desenvolvedor'
      mateus_profile = PortifoliorrrProfile.new id: 2, name: 'Mateus', job_category: 'Designer'
      rodolfo_profile = PortifoliorrrProfile.new id: 3, name: 'Rodolfo', job_category: 'Editor de Video'
      portifoliorrr_profiles = [lucas_profile, mateus_profile, rodolfo_profile]
      allow(PortifoliorrrProfile).to receive(:all).and_return(portifoliorrr_profiles)

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

    context 'buscando por termo' do
      it 'com sucesso' do
        user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
        project = create(:project, user:)
        project.user_roles.find_by(user:).update(role: :leader)
        rodolfo_profile = PortifoliorrrProfile.new id: 3, name: 'Rodolfo', job_category: 'Editor de Video'
        allow(PortifoliorrrProfile).to receive(:find).with('video').and_return([rodolfo_profile])

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

      it 'e não há resultados' do
        user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
        project = create(:project, user:)
        project.user_roles.find_by(user:).update(role: :leader)
        allow(PortifoliorrrProfile).to receive(:find).with('termo maluco').and_return([])

        login_as user
        visit search_project_portifoliorrr_profiles_path project
        fill_in 'Busca:', with: 'termo maluco'
        click_on 'Buscar'

        expect(current_path).to eq search_project_portifoliorrr_profiles_path project
        expect(page).to have_content 'Resultados para: termo maluco'
        expect(page).to have_content 'Não há usuários a serem exibidos.'
      end
    end
  end
end
