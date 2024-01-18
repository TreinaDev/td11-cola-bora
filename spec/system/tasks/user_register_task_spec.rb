require 'rails_helper'

describe 'Usuário cria tarefa' do
  it 'á partir da pagina princial do projeto' do
    user = create(:user, email: 'joão@email.com', password: 'password', cpf: '123456')
    project = create(:project, user:)

    # TODO
    # rota á partir da home
    visit new_project_task_path(project)
    fill_in 'Responsável', with: 'João'
    fill_in 'Título', with: 'Bugfix do projeto'
    fill_in 'Descrição', with: 'Conserta o erro tal do arquivo tal'
    fill_in 'Prazo', with: 10.days.from_now
    click_on 'Criar Tarefa'

    expect(page).to have_content('Tarefa criada com sucesso')
    expect(page).to have_content('Título: Bugfix do projeto')
    expect(page).to have_content('Descrição: Conserta o erro tal do arquivo tal')
    expect(page).to have_content("Prazo: #{10.days.from_now}")
  end
end
