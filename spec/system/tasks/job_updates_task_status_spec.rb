require 'rails_helper'

describe 'Job expira tarefa' do
  it 'em progresso' do
    project = create :project
    author = create :user, cpf: '979.612.040-24'
    author_role = create :user_role, project:, user: author, role: :contributor

    expired_task_spy = spy(ExpireTaskJob)
    stub_const('ExpireTaskJob', expired_task_spy)

    task = create(:task, project:, user_role: author_role, due_date: 2.days.from_now.to_date, status: :in_progress)

    expect(expired_task_spy).to have_received(:perform_later).with(task).once
  end

  it 'não iniciado' do
    project = create :project
    author = create :user, cpf: '979.612.040-24'
    author_role = create :user_role, project:, user: author, role: :contributor

    expired_task_spy = spy(ExpireTaskJob)
    stub_const('ExpireTaskJob', expired_task_spy)

    task = create(:task, project:, user_role: author_role, due_date: 2.days.from_now.to_date, status: :uninitialized)

    expect(expired_task_spy).to have_received(:perform_later).with(task).once
  end

  it 'quando uma tarefa é criada sem prazo e depois atualizada com prazo' do
    project = create :project
    author = create :user, cpf: '979.612.040-24'
    author_role = create :user_role, project:, user: author, role: :contributor
    task = create(:task, project:, user_role: author_role, due_date: nil, status: :uninitialized)

    expired_task_spy = spy(ExpireTaskJob)
    stub_const('ExpireTaskJob', expired_task_spy)

    task.update(due_date: 1.day.from_now.to_date)

    expect(expired_task_spy).to have_received(:perform_later).with(task).once
  end

  it 'quando a tarefa é criada com prazo e depois é alterada para prazo maior' do
    project = create :project
    author = create :user, cpf: '979.612.040-24'
    author_role = create :user_role, project:, user: author, role: :contributor

    expired_task_spy = spy(ExpireTaskJob)
    stub_const('ExpireTaskJob', expired_task_spy)

    task = create(:task, project:, user_role: author_role, due_date: 1.day.from_now.to_date, status: 'uninitialized')

    task.update(due_date: 2.days.from_now.to_date)

    expect(expired_task_spy).to have_received(:perform_later).with(task).twice
  end
end
