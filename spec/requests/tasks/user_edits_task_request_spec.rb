require 'rails_helper'

describe 'Usuário edita uma tarefa' do
  it 'e não é o lider do projeto, o autor ou responsável' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:, title: 'Corrige Bug', author:, assigned: author)
    user = create(:user, email: 'ana@email.com', password: 'password', cpf: '61151615099')

    login_as(user)
    patch(task_path(task), params: { task: { title: 'Bugfix' } })

    expect(task.reload.title).not_to eq 'Bugfix'
    expect(response).to redirect_to(root_path)
  end

  it 'e é o lider do projeto, o autor ou responsável' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:, title: 'Corrige Bug', author:, assigned: author)

    login_as(author)
    patch(task_path(task), params: { task: { title: 'Bugfix' } })

    expect(task.reload.title).to eq 'Bugfix'
    expect(response).to redirect_to(task_path(task))
  end
end
