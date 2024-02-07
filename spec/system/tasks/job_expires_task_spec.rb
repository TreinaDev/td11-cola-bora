require 'rails_helper'

describe 'Job expira tarefa' do
  it 'em progresso' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)

    expired_task_spy = spy(ExpiredTaskJob)
    stub_const('ExpiredTaskJob', expired_task_spy)

    task = create(:task, project:, due_date: 2.days.from_now.to_date, status: 'in_progress')

    expect(expired_task_spy).to have_received(:perform_later).with(task).once
  end

  it 'não iniciado' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)

    expired_task_spy = spy(ExpiredTaskJob)
    stub_const('ExpiredTaskJob', expired_task_spy)

    task = create(:task, project:, due_date: 2.days.from_now.to_date, status: 'uninitialized')

    expect(expired_task_spy).to have_received(:perform_later).with(task).once
  end
end
