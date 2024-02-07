require 'rails_helper'

describe 'Usuário edita Tarefa' do
  it 'e é contribuinte autor da tarefa' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    task = create(:task, project:, user_role: contributor_role, title: 'Tarefa de capturar 150 Pokémons')

    login_as contributor, scope: :user
    patch(project_task_path(project, task), params: { task: { title: 'Tarefa sair de casa com 10 anos' } })

    expect(response).to redirect_to project_task_path(project, task)
    expect(task.reload.title).to eq 'Tarefa sair de casa com 10 anos'
  end

  it 'e é contribuinte do projeto não autor da tarefa' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: contributor, role: :contributor)
    task = create(:task, project:, user_role: leader.user_roles.first, title: 'tarefa blabla')

    login_as contributor, scope: :user
    patch(project_task_path(project, task), params: { task: { title: 'tarefa do Rock in rio' } })

    expect(task.reload.title).to eq 'tarefa blabla'
    expect(response).to redirect_to project_task_path(project, task)
  end

  it 'e é um líder não autor da tarefa' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    task = create(:task, project:, user_role: contributor_role, title: 'tarefa blabla')

    login_as leader, scope: :user
    patch(project_task_path(project, task), params: { task: { title: 'tarefa do Rock in rio' } })

    expect(task.reload.title).to eq 'tarefa do Rock in rio'
    expect(response).to redirect_to project_task_path(project, task)
  end

  it 'e é um administrador não autor da tarefa' do
    leader = create(:user)
    project = create(:project, user: leader)
    admin = create(:user, email: 'admin@email.com', cpf: '000.000.001-91')
    project.user_roles.create!(user: admin, role: :admin)
    task = create(:task, project:, user_role: leader.user_roles.first, title: 'tarefa blabla')

    login_as admin, scope: :user
    patch(project_task_path(project, task), params: { task: { title: 'tarefa do Rock in rio' } })

    expect(task.reload.title).to eq 'tarefa do Rock in rio'
    expect(response).to redirect_to project_task_path(project, task)
  end
end
