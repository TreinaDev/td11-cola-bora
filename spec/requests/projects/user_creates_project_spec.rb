require 'rails_helper'

describe 'Usuário cria um projeto' do
  it 'e deve estar autenticado' do
    user = create :user
    project_params = { title: 'Mewtwo', description: 'Um projeto para criar um pokémon.', category: 'Jogo', user: }
    initial_project_count = Project.count

    post projects_path, params: { project: project_params }
    project_count = Project.count

    expect(response).to redirect_to new_user_session_path
    expect(project_count).to eq(initial_project_count)
  end

  it 'com sucesso' do
    user = create :user
    project_params = { title: 'Mewtwo', description: 'Um projeto para criar um pokémon.', category: 'Jogo', user: }
    initial_project_count = Project.count

    login_as(user)
    post projects_path, params: { project: project_params }

    expect(Project.count).to eq(initial_project_count + 1)
    expect(response).not_to redirect_to new_user_session_path
  end
end
