require 'rails_helper'

describe 'Usuário acessa lista de solicitações de um projeto' do
  it 'do qual é líder' do
    leader = create :user
    project = create :project, user: leader

    login_as leader, scope: :user
    get project_proposals_path project

    expect(response).to have_http_status :ok
  end

  it 'do qual é administrador' do
    project = create :project
    admin = create :user, cpf: '518.642.180-45'
    create :user_role, project:, user: admin, role: :admin

    login_as admin, scope: :user
    get project_proposals_path project

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end

  it 'do qual é colaborador' do
    project = create :project
    contributor = create :user, cpf: '518.642.180-45'
    create :user_role, project:, user: contributor, role: :contributor

    login_as contributor, scope: :user
    get project_proposals_path project

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end

  it 'do qual não participa' do
    project = create :project
    non_member = create :user, cpf: '518.642.180-45'

    login_as non_member, scope: :user
    get project_proposals_path project

    expect(response).to redirect_to root_path
    expect(flash[:alert]).to eq 'Você não tem acesso a esse recurso'
  end

  it 'sem estar autenticado' do
    project = create :project

    get project_proposals_path project

    expect(response).to redirect_to new_user_session_path
  end
end
