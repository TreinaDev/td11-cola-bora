require 'rails_helper'

describe 'Usuário vê tarefas' do
  it 'em um index' do
    project = create(:project)
    create(:task, title: 'Tarefa 1', project:)
    create(:task, title: 'Tarefa 2', project:)
    create(:task, title: 'Tarefa 3', project:)
    create(:task, title: 'Tarefa 4', project:)

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
    create(:task, title: 'Tarefa 1', project:)
    task = create(:task, title: 'Tarefa 2', project:, description: 'Fazer item 8 do backlog',
                         due_date: nil, assigned: nil)

    login_as(project.user)
    visit project_path(project)
    click_on 'Tarefas'
    click_on 'Tarefa 2'

    expect(page).to have_content 'Tarefa 2'
    expect(page).to have_content "Descrição\nFazer item 8 do backlog"
    expect(page).to have_content "Prazo\nSem prazo"
    expect(page).to have_content "Responsável\nSem responsável"
    expect(current_path).to eq task_path(task)
  end
end
