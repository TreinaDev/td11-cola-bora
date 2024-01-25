require 'rails_helper'

describe 'Líder de projeto vê detalhes de um perfil da Portifoliorrr' do
  it 'e deve estar autenticado' do
    project = create :project
    profile_id = 1

    visit project_portifoliorrr_profile_path project, profile_id

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e não pode ser colaborador' do
    project = create :project
    user = create :user, cpf: '149.759.780-32', email: 'contributor@email.com'
    create(:user_role, user:, project:, role: :contributor)
    profile_id = 1

    login_as user
    visit project_portifoliorrr_profile_path project, profile_id

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  it 'e não pode ser administrador' do
    project = create :project
    user = create :user, cpf: '149.759.780-32', email: 'administrador@email.com'
    create(:user_role, user:, project:, role: :admin)
    profile_id = 1

    login_as user
    visit project_portifoliorrr_profile_path project, profile_id

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  it 'com sucesso a partir da home' do
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    project = create :project, user:, title: 'Projeto Top'
    project.user_roles.find_by(user:).update(role: :leader)
    mateus_profile = PortifoliorrrProfile.new id: 2, name: 'Rodolfo', job_category: 'Designer'
    allow(PortifoliorrrProfile).to receive(:all).and_return([mateus_profile])
    mateus_profile.email = 'rodolfo@email.com'
    first_job_category = JobCategory.new(name: 'Editor de Video', description: 'Canal do Youtube')
    second_job_category = JobCategory.new(name: 'Editor de Imagem', description: 'Photoshop')
    mateus_profile.job_categories = [first_job_category, second_job_category]
    mateus_profile.cover_letter = 'Sou editor de vídeos em um canal do Youtube.'
    allow(PortifoliorrrProfile).to receive(:find).and_return(mateus_profile)

    login_as user
    visit root_path
    click_on 'Projetos'
    click_on 'Projeto Top'
    click_on 'Procurar usuários'
    click_on 'Rodolfo'

    expect(current_path).to eq project_portifoliorrr_profile_path project, mateus_profile.id
    expect(page).to have_content 'Perfil de Rodolfo'
    expect(page).to have_content 'Nome: Rodolfo'
    expect(page).to have_content 'Email: rodolfo@email.com'
    expect(page).to have_content 'Tipos de Serviço:'
    expect(page).to have_content 'Nome: Editor de Video'
    expect(page).to have_content 'Descrição: Canal do Youtube'
    expect(page).to have_content 'Nome: Editor de Imagem'
    expect(page).to have_content 'Descrição: Photoshop'
    expect(page).to have_content 'Sobre mim: Sou editor de vídeos em um canal do Youtube.'
  end

  it 'e não há resultado' do
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    project = create :project, user:, title: 'Projeto Top'
    project.user_roles.find_by(user:).update(role: :leader)
    allow(PortifoliorrrProfile).to receive(:find).and_return({})

    login_as user
    visit project_portifoliorrr_profile_path project, 999

    expect(page).to have_content 'Perfil não disponível'
    expect(page).to have_content 'Tente mais tarde'
  end
end
