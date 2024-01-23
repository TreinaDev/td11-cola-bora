require 'rails_helper'

describe 'Líder de projeto pesquisa por colaboradores' do
  it 'e deve estar autenticado' do
    project = create :project

    visit search_project_collaborators_path project

    expect(current_path).to eq new_user_session_path
    expect(page).to have_content 'Para continuar, faça login ou registre-se'
  end

  it 'e não pode ser contribuidor' do
    project = create :project
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    create :user_role, user:, project:, role: :contributor

    login_as user
    visit search_project_collaborators_path project

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  it 'e não pode ser administrador' do
    project = create :project
    user = create :user, email: 'user@email.com', cpf: '149.759.780-32'
    create :user_role, user:, project:, role: :admin

    login_as user
    visit search_project_collaborators_path project

    expect(current_path).to eq root_path
    expect(page).to have_content 'Você não tem acesso a esse recurso'
  end

  xit 'e não há colaboradores a serem exibidos'

  context 'com sucesso a partir da home' do
    xit 'buscando por todos'

    xit 'buscando por termo'
  end
end
