require 'rails_helper'

describe 'Usuário vê tarefas' do
  it 'em um index' do
    project = create(:project)
    author = project.user
    author_role = create(:user_role, user: author, project:)
    create(:task, title: 'Tarefa 1', project:, user_role: author_role)
    create(:task, title: 'Tarefa 2', project:, user_role: author_role)
    create(:task, title: 'Tarefa 3', project:, user_role: author_role)
    create(:task, title: 'Tarefa 4', project:, user_role: author_role)

    login_as(project.user)
    visit project_path(project)
    click_on 'Tarefas'

    expect(page).to have_content 'Tarefas'
    expect(page).to have_link 'Tarefa 1'
    expect(page).to have_link 'Tarefa 2'
    expect(page).to have_link 'Tarefa 3'
    expect(page).to have_link 'Tarefa 4'
    expect(current_path).to eq project_tasks_path(project)
  end

  it 'à partir do index' do
    project = create(:project)
    author = project.user
    author_role = create(:user_role, user: author, project:)
    create(:task, title: 'Tarefa 1', project:, user_role: author_role)
    task = create(:task, title: 'Tarefa 2', project:, description: 'Fazer item 8 do backlog',
                         due_date: nil, assigned: nil, user_role: author_role)

    login_as(project.user)
    visit project_path(project)
    click_on 'Tarefas'
    click_on 'Tarefa 2'

    expect(page).to have_content 'Tarefa 2'
    expect(page).to have_content "Descrição\nFazer item 8 do backlog"
    expect(page).to have_content "Prazo\nSem prazo"
    expect(page).to have_content "Responsável\nSem responsável"
    expect(current_path).to eq project_task_path(project, task)
  end

  it 'e volta para a página do projeto' do
    project = create(:project, title: 'Projeto Secreto', description: 'Esse projeto é secreto')
    author = project.user
    author_role = create(:user_role, user: author, project:)
    create(:task, title: 'Tarefa 1', project:, user_role: author_role)
    create(:task, title: 'Tarefa 2', project:, user_role: author_role)
    create(:task, title: 'Tarefa 3', project:, user_role: author_role)
    create(:task, title: 'Tarefa 4', project:, user_role: author_role)

    login_as(project.user)
    visit project_path(project)
    click_on 'Tarefas'
    click_on 'Tarefa 2'
    click_on 'Voltar'

    expect(page).to have_content 'Tarefas'
    expect(page).to have_link 'Tarefa 1'
    expect(page).to have_link 'Tarefa 2'
    expect(page).to have_link 'Tarefa 3'
    expect(page).to have_link 'Tarefa 4'
    expect(current_path).to eq project_tasks_path(project)
  end

  it 'e acessa uma tarefa de um participante removido do projeto' do
    leader = create :user, cpf: '850.265.590-69', email: 'participant1@email.com'
    project = create :project, user: leader
    author = create :user, cpf: '875.898.470-46'
    author.profile.update first_name: 'João', last_name: 'Almeida'
    author_role = create :user_role, project:, user: author, role: :contributor
    task = create :task, project:, user_role: author_role, title: 'Planejamento estratégico',
                         description: 'Vamos planejar a estratégia'
    author_role.update active: false

    login_as leader
    visit project_task_path project, task

    expect(page).to have_content 'João Almeida'
    expect(page).to have_content 'Planejamento estratégico'
    expect(page).to have_content 'Vamos planejar a estratégia'
  end
end
