require 'rails_helper'

describe 'Usuário vê' do
  it 'index de tarefas' do
    project = create(:project)
    create(:task, title: 'Tarefa 1', project:)
    create(:task, title: 'Tarefa 2', project:)
    create(:task, title: 'Tarefa 3', project:)
    create(:task, title: 'Tarefa 4', project:)

    visit project_path(project)
    click_on 'Tarefas'

    expect(page).to have_content 'Tarefas'
    expect(page).to have_link 'Tarefa 1'
    expect(page).to have_link 'Tarefa 2'
    expect(page).to have_link 'Tarefa 3'
    expect(page).to have_link 'Tarefa 4'
    expect(current_path).to eq project_tasks_path(project)
  end
end
