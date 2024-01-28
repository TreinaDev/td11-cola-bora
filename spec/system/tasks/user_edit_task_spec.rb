require 'rails_helper'

describe 'Usuário edita tarefa' do
  it 'a partir da página de tarefa com sucesso' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:)

    login_as(author)
    visit task_path(task)
    click_on 'Editar Tarefa'
    fill_in 'Título', with: 'Conserta a tarefa'
    fill_in 'Descrição', with: 'Essa edição conserta a tarefa'
    click_on 'Salvar'

    expect(page).to have_content('Tarefa editada com sucesso')
    expect(page).to have_content('Tarefa: Conserta a tarefa')
    expect(page).to have_content("Descrição\nEssa edição conserta a tarefa")
  end

  it 'e falha porque um campo obrigatório ficou em branco' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    project = create(:project, user: author)
    task = create(:task, project:)

    login_as(author)
    visit task_path(task)
    click_on 'Editar Tarefa'
    fill_in 'Título', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível editar a tarefa.')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(page).to have_content('Editar Tarefa')
    expect(page).to have_field('Título')
    expect(page).to have_field('Descrição')
  end
end
