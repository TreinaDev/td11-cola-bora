require 'rails_helper'

describe 'Usuário altera status de tarefa' do
  it 'e é autor contribuinte' do
    leader = create(:user)
    project = create(:project, user: leader)
    contributor = create(:user, email: 'contributor@email.com', cpf: '000.000.001-91')
    contributor_role = project.user_roles.create!(user: contributor)
    task = create(:task, project:, user_role: contributor_role, status: :in_progress)

    mail = double('mail', deliver: true)
    mailer_double = double('TaskMailer', notify_leader_finish_task: mail)

    allow(TaskMailer).to receive(:with).and_return(mailer_double)
    allow(mailer_double).to receive(:notify_leader_finish_task).and_return(mail)

    login_as contributor, scope: :user
    patch(finish_project_task_path(project, task))

    expect(task.reload.status).to eq 'finished'
    expect(mail).to have_received(:deliver)
  end
end
