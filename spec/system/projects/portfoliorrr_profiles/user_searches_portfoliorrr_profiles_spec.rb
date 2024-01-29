require 'rails_helper'

describe 'Usuário pesquisa por perfis da Portfoliorrr' do
  it 'e deve estar autenticado' do
    project = create :project

    visit search_project_portfoliorrr_profiles_path project

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  context 'e não pode ser contribuidor' do
    it 'para acessar a página' do
      project = create :project
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      create :user_role, user:, project:, role: :contributor

      login_as user
      visit search_project_portfoliorrr_profiles_path project

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
      visit search_project_portfoliorrr_profiles_path project

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

  it 'e é lider apenas de outro projeto' do
    project = create :project
    other_leader = create :user, email: 'otherleader@email.com', cpf: '149.759.780-32'
    create :project, user: other_leader, title: 'Outro Projeto'

    login_as other_leader
    visit search_project_portfoliorrr_profiles_path project

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  context 'com sucesso sendo líder do projeto' do
    it 'buscando por todos' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      portfoliorrr_profiles = [
        PortfoliorrrProfile.new(id: 1, name: 'Lucas', job_categories: [JobCategory.new(name: 'Desenvolvedor')]),
        PortfoliorrrProfile.new(id: 2, name: 'Mateus', job_categories: [JobCategory.new(name: 'Designer')]),
        PortfoliorrrProfile.new(id: 3, name: 'Rodolfo', job_categories: [JobCategory.new(name: 'Editor de Video')])
      ]
      allow(PortfoliorrrProfile).to receive(:all).and_return(portfoliorrr_profiles)

      login_as user
      visit root_path
      click_on 'Projetos'
      click_on 'Projeto Top'
      click_on 'Procurar usuários'

      expect(current_path).to eq search_project_portfoliorrr_profiles_path project
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

    it 'e não há colaboradores a serem exibidos' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)
      allow(PortfoliorrrProfile).to receive(:all).and_return([])

      login_as user
      visit search_project_portfoliorrr_profiles_path project

      expect(page).to have_content 'Não há usuários a serem exibidos.'
    end

    context 'buscando por termo' do
      it 'com sucesso' do
        user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
        project = create(:project, user:)
        project.user_roles.find_by(user:).update(role: :leader)
        rodolfo_profile = PortfoliorrrProfile.new id: 3, name: 'Rodolfo',
                                                  job_categories: [
                                                    JobCategory.new(name: 'Editor de Video'),
                                                    JobCategory.new(name: 'Editor de Imagem')
                                                  ]
        allow(PortfoliorrrProfile).to receive(:search).with('video').and_return([rodolfo_profile])

        login_as user
        visit search_project_portfoliorrr_profiles_path project
        fill_in 'Busca', with: 'video'
        click_on 'Buscar'

        expect(current_path).to eq search_project_portfoliorrr_profiles_path project
        expect(page).to have_content 'Resultados para: video'
        expect(page).not_to have_content 'Lucas'
        expect(page).not_to have_content 'Desenvolvedor'
        expect(page).not_to have_content 'Mateus'
        expect(page).not_to have_content 'Designer'
        expect(page).to have_content 'Rodolfo'
        expect(page).to have_content 'Editor de Video e Editor de Imagem'
      end

      it 'e não há resultados' do
        user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
        project = create(:project, user:)
        project.user_roles.find_by(user:).update(role: :leader)
        allow(PortfoliorrrProfile).to receive(:search).with('termo maluco').and_return([])

        login_as user
        visit search_project_portfoliorrr_profiles_path project
        fill_in 'Busca', with: 'termo maluco'
        click_on 'Buscar'

        expect(current_path).to eq search_project_portfoliorrr_profiles_path project
        expect(page).to have_content 'Resultados para: termo maluco'
        expect(page).to have_content 'Não há usuários a serem exibidos.'
      end
    end

    it 'e volta para a página de projetos' do
      user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
      project = create(:project, user:)
      project.user_roles.find_by(user:).update(role: :leader)
      allow(PortfoliorrrProfile).to receive(:all).and_return([])

      login_as user
      visit search_project_portfoliorrr_profiles_path project
      click_on 'Voltar'

      expect(current_path).to eq project_path project
    end
  end
end
