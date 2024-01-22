require 'rails_helper'

describe 'Usuário atualiza o status da tarefa' do
  it 'de não iniciada para em andamento' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:)

    login_as(author)
    visit task_path(task)
    click_on 'Iniciar Tarefa'

    expect(page).to have_content "Status\nEm andamento"
    expect(page).to have_content 'Tarefa iniciada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).to have_current_path(task_path(task))
    expect(task.reload.status).to eq 'in_progress'
  end

  it 'de em andamento para finalizada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:, status: 'in_progress')

    login_as(author)
    visit task_path(task)
    click_on 'Finalizar Tarefa'

    expect(page).to have_content "Status\nFinalizada"
    expect(page).to have_content 'Tarefa finalizada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(task_path(task))
    expect(task.reload.status).to eq 'finished'
  end

  it 'de não iniciada para cancelada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:, status: 'uninitialized')

    login_as(author)
    visit task_path(task)
    click_on 'Cancelar Tarefa'

    expect(page).to have_content "Status\nCancelada"
    expect(page).to have_content 'Tarefa cancelada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(task_path(task))
    expect(task.reload.status).to eq 'cancelled'
  end

  it 'de em andamento para cancelada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:, status: 'in_progress')

    login_as(author)
    visit task_path(task)
    click_on 'Cancelar Tarefa'

    expect(page).to have_content "Status\nCancelada"
    expect(page).to have_content 'Tarefa cancelada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(task_path(task))
    expect(task.reload.status).to eq 'cancelled'
  end
end
