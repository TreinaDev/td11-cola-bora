require 'rails_helper'

describe 'Usuário vê detalhes de um perfil da Portfoliorrr' do
  it 'e deve estar autenticado' do
    project = create :project
    profile_id = 1

    visit project_portfoliorrr_profile_path project, profile_id

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e não pode ser colaborador' do
    project = create :project
    user = create :user, cpf: '149.759.780-32'
    create(:user_role, user:, project:, role: :contributor)
    profile_id = 1

    login_as user
    visit project_portfoliorrr_profile_path project, profile_id

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  it 'e não pode ser administrador' do
    project = create :project
    user = create :user, cpf: '149.759.780-32'
    create(:user_role, user:, project:, role: :admin)
    profile_id = 1

    login_as user
    visit project_portfoliorrr_profile_path project, profile_id

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  it 'e é lider apenas de outro projeto' do
    project = create :project
    other_leader = create :user, cpf: '149.759.780-32'
    create :project, user: other_leader, title: 'Outro Projeto'
    profile_id = 1

    login_as other_leader
    visit project_portfoliorrr_profile_path project, profile_id

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  context 'com sucesso sendo líder do projeto' do
    it 'a partir da pagina inicial' do
      user = create :user, cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      rodolfo_profile = PortfoliorrrProfile.new id: 2, name: 'Rodolfo',
                                                job_categories: [JobCategory.new(name: 'Designer')]
      allow(PortfoliorrrProfile).to receive(:all).and_return([rodolfo_profile])
      rodolfo_profile.job_categories = [
        JobCategory.new(name: 'Editor de Video', description: 'Canal do Youtube'),
        JobCategory.new(name: 'Editor de Imagem', description: 'Photoshop')
      ]
      rodolfo_profile.email = 'rodolfo@email.com'
      rodolfo_profile.cover_letter = 'Sou editor de vídeos em um canal do Youtube.'
      allow(PortfoliorrrProfile).to receive(:find).and_return(rodolfo_profile)

      login_as user
      visit root_path
      click_on 'Projetos'
      click_on 'Projeto Top'
      within '#project-navbar' do
        click_on 'Procurar usuários'
      end
      click_on 'Rodolfo'

      expect(current_path).to eq project_portfoliorrr_profile_path project, rodolfo_profile.id
      expect(page).to have_content 'Projeto Top - Recrutamento de colaboradores'
      expect(page).to have_content 'Perfil de Rodolfo'
      expect(page).to have_content "Nome\nRodolfo"
      expect(page).to have_content "E-mail\nrodolfo@email.com"
      expect(page).to have_content "Editor de Video\nCanal do Youtube"
      expect(page).to have_content "Editor de Imagem\nPhotoshop"
      expect(page).to have_content "Sobre mim\nSou editor de vídeos em um canal do Youtube."
    end

    it 'e também é lider de outro projeto' do
      user = create :user
      create(:project, user:, title: 'Primeiro Projeto')
      second_project = create(:project, user:, title: 'Segundo Projeto')
      profile_id = 1

      login_as user
      visit project_portfoliorrr_profile_path second_project, profile_id

      expect(current_path).to eq project_portfoliorrr_profile_path second_project, profile_id
      expect(page).not_to have_content 'Você não tem acesso a esse recurso'
    end

    it 'e não há resultado' do
      user = create :user, cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      allow(PortfoliorrrProfile).to receive(:find).and_return({})

      login_as user
      visit project_portfoliorrr_profile_path project, 999

      expect(page).to have_content 'Perfil não disponível'
      expect(page).to have_content 'Tente novamente mais tarde'
    end

    it 'e volta para a página de busca' do
      user = create :user, cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      profile_id = 1
      allow(PortfoliorrrProfile).to receive(:find).and_return({})
      allow(PortfoliorrrProfile).to receive(:all).and_return([])

      login_as user
      visit project_portfoliorrr_profile_path project, profile_id
      click_on 'Voltar'

      expect(current_path).to eq search_project_portfoliorrr_profiles_path project
      expect(page).to have_field 'Busca'
      expect(page).to have_button 'Buscar'
    end
  end
end
