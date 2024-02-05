require 'rails_helper'

describe 'Usuário vê detalhes de uma tarefa' do
  it 'com sucesso' do
    project = create(:project)
    create(:task, title: 'Tarefa 1', project:)
    task = create(:task, title: 'Tarefa 2', project:, description: 'Fazer item 8 do backlog',
                         due_date: nil, assigned: nil)
    finalizamos essa tarefa
  end
end
