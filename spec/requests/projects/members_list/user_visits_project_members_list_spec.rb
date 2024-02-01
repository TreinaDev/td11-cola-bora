require 'rails_helper'

describe 'Usuário acessa lista de colaboradores de um projeto' do
  it 'sem estar autenticado' do
    project = create :project

    get members_project_path(project)

    expect(response).to redirect_to new_user_session_path
  end

  it 'do qual não faz parte' do
    project = create :project
    non_member = create :user, cpf: '878.228.650-72'

    login_as non_member
    get members_project_path(project)

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não é um colaborador desse projeto'
  end
end
