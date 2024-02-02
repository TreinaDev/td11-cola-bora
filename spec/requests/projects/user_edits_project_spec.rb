require 'rails_helper'

describe 'Usuário edita projeto' do
  it 'e é líder' do
    project = create(:project, title: 'Projeto Math')
    user = project.user

    login_as user, scope: :user
    patch(project_path(project), params: { project: { title: 'Projeto Port' } })

    expect(response).to redirect_to project_path(project)
    expect(project.reload.title).to eq 'Projeto Port'
  end

  it 'e é administrador' do
    user = create(:user)
    project = create(:project, title: 'Projeto Math', user:)
    admin = create(:user, cpf: '32823816038')
    create(:user_role, project:, role: :admin, user: admin)

    login_as admin, scope: :user
    patch(project_path(project), params: { project: { title: 'Projeto Port' } })

    expect(response).to redirect_to project_path(project)
    expect(project.reload.title).to eq 'Projeto Math'
    expect(flash[:alert]).to eq 'Você não possui permissão para prosseguir'
  end

  it 'e é contribuinte' do
    user = create(:user)
    project = create(:project, title: 'Projeto Math', user:)
    contributor = create(:user, cpf: '32823816038')
    create(:user_role, project:, role: :contributor, user: contributor)

    login_as contributor, scope: :user
    patch(project_path(project), params: { project: { title: 'Projeto Port' } })

    expect(response).to redirect_to project_path(project)
    expect(project.reload.title).to eq 'Projeto Math'
    expect(flash[:alert]).to eq 'Você não possui permissão para prosseguir'
  end

  it 'e não é membro' do
    user = create(:user)
    project = create(:project, title: 'Projeto Math', user:)

    not_member = create(:user, cpf: '32823816038')

    login_as not_member, scope: :user
    patch(project_path(project), params: { project: { title: 'Projeto Port' } })

    expect(response).to redirect_to project_path(project)
    expect(project.reload.title).to eq 'Projeto Math'
    expect(flash[:alert]).to eq 'Você não possui permissão para prosseguir'
  end

  it 'e não está autenticado' do
    user = create(:user)
    project = create(:project, title: 'Projeto Math', user:)

    patch(project_path(project), params: { project: { title: 'Projeto Port' } })

    expect(response).to redirect_to new_user_session_path
    expect(project.reload.title).to eq 'Projeto Math'
  end
end
