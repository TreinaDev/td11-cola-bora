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
                                                job_categories: [JobCategory.new(id: 1, name: 'Designer')]
      allow(PortfoliorrrProfile).to receive(:all).and_return([rodolfo_profile])

      login_as user
      visit root_path
      click_on 'Projetos'
      click_on 'Projeto Top'
      within '#project-navbar' do
        click_on 'Procurar usuários'
      end

      expect(page).to have_link 'Rodolfo', href: project_portfoliorrr_profile_path(project, rodolfo_profile.id)
    end

    it 'com sucesso' do
      user = create :user, cpf: '149.759.780-32'
      project = create :project, user:, title: 'Projeto Top'
      project.user_roles.find_by(user:).update(role: :leader)
      rodolfo_profile = PortfoliorrrProfile.new id: 2, name: 'Rodolfo',
                                                job_categories: [
                                                  JobCategory.new(id: 1, name: 'Editor de Video',
                                                                  description: 'Canal do Youtube'),
                                                  JobCategory.new(id: 2, name: 'Editor de Imagem',
                                                                  description: 'Photoshop')
                                                ]
      rodolfo_profile.email = 'rodolfo@email.com'
      rodolfo_profile.cover_letter = 'Sou editor de vídeos em um canal do Youtube.'
      rodolfo_profile.education_infos = [{ "institution": 'Senai',
                                           "course": 'Web dev full stack',
                                           "start_date": Date.parse('2022-12-12'),
                                           "end_date": nil }]
      rodolfo_profile.professional_infos = [{ "company": 'Campus Code',
                                              "position": 'Dev',
                                              "start_date": Date.parse('2022-12-12'),
                                              "end_date": Date.parse('2023-12-12'),
                                              "description": 'Muito código',
                                              "current_job": false }]
      allow(PortfoliorrrProfile).to receive(:find).and_return(rodolfo_profile)

      login_as user
      visit project_portfoliorrr_profile_path project, rodolfo_profile.id

      expect(page).to have_current_path project_portfoliorrr_profile_path project, rodolfo_profile.id
      expect(page).to have_content 'Projeto: Projeto Top'
      expect(page).to have_content 'Perfil de Rodolfo'
      expect(page).to have_content "Nome\nRodolfo"
      expect(page).to have_content "E-mail\nrodolfo@email.com"
      expect(page).to have_content "Editor de Video\nCanal do Youtube"
      expect(page).to have_content "Editor de Imagem\nPhotoshop"
      expect(page).to have_content "Sobre mim\n\"Sou editor de vídeos em um canal do Youtube.\""

      expect(page).to have_content 'Educação'
      expect(page).to have_content 'Instituição: Senai'
      expect(page).to have_content 'Curso: Web dev full stack'
      expect(page).to have_content 'Data de Início: 12/12/2022'
      expect(page).to have_content 'Data de Término: ---'

      expect(page).to have_content 'Experiência Profissional'
      expect(page).to have_content 'Posição:'
      expect(page).to have_content 'Data de Início: 12/12/2022'
      expect(page).to have_content 'Data de Término: 12/12/2023'
      expect(page).to have_content 'Descrição'
      expect(page).to have_content 'Emprego Atual: Não'
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
      click_on 'Procurar usuários'

      expect(page).to have_current_path search_project_portfoliorrr_profiles_path project
      expect(page).to have_field 'Busca'
      expect(page).to have_button 'Buscar'
    end
  end
end
