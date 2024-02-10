require 'rails_helper'

describe 'Usuário atualiza o status da tarefa' do
  it 'de não iniciada para em andamento' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    author_role = create(:user_role, user: author, project:)
    task = create(:task, project:, user_role: author_role)

    login_as(author)
    visit project_task_path(project, task)
    click_on 'Iniciar Tarefa'

    expect(page).to have_content "Status\nEm andamento"
    expect(page).to have_content 'Tarefa iniciada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).to have_current_path(project_task_path(project, task))
    expect(task.reload.status).to eq 'in_progress'
  end

  it 'de em andamento para finalizada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    author_role = create(:user_role, user: author, project:)
    task = create(:task, project:, status: 'in_progress', user_role: author_role)

    mail = double('mail', deliver: true)
    mailer_double = double('TaskMailer', notify_leader_finish_task: mail)

    allow(TaskMailer).to receive(:with).and_return(mailer_double)
    allow(mailer_double).to receive(:notify_leader_finish_task).and_return(mail)

    login_as(author)
    visit project_task_path(project, task)
    click_on 'Finalizar Tarefa'

    expect(page).to have_content "Status\nFinalizada"
    expect(page).to have_content 'Tarefa finalizada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(project_task_path(project, task))
    expect(task.reload.status).to eq 'finished'
    expect(mail).to have_received(:deliver)
  end

  it 'de não iniciada para cancelada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    author_role = create(:user_role, user: author, project:)
    task = create(:task, project:, status: 'uninitialized', user_role: author_role)

    login_as(author)
    visit project_task_path(project, task)
    accept_confirm('Cancelar tarefa?') { click_on 'Cancelar Tarefa' }

    expect(page).to have_content "Status\nCancelada"
    expect(page).to have_content 'Tarefa cancelada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(project_task_path(project, task))
    expect(task.reload.status).to eq 'cancelled'
  end

  it 'de em andamento para cancelada' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    author_role = create(:user_role, user: author, project:)
    task = create(:task, project:, status: 'in_progress', user_role: author_role)

    login_as(author)
    visit project_task_path(project, task)
    accept_confirm('Cancelar tarefa?') { click_on 'Cancelar Tarefa' }

    expect(page).to have_content "Status\nCancelada"
    expect(page).to have_content 'Tarefa cancelada'
    expect(page).not_to have_button 'Iniciar Tarefa'
    expect(page).not_to have_button 'Finalizar Tarefa'
    expect(page).to have_current_path(project_task_path(project, task))
    expect(task.reload.status).to eq 'cancelled'
  end
end
