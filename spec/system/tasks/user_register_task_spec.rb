require 'rails_helper'

describe 'Usuário cria tarefa' do
  it 'á partir da pagina princial do projeto' do
    author = create(:user, email: 'joão@email.com', password: 'password', cpf: '123456')
    create(:user, email: 'valeria@email.com', password: 'password', cpf: '123457')
    project = create(:project, user: author)

    login_as(author)
    visit project_path(project)
    click_on 'Nova Tarefa'
    fill_in 'Título', with: 'Bugfix do projeto'
    fill_in 'Descrição', with: 'Conserta o erro tal do arquivo tal'
    fill_in 'Prazo', with: 10.days.from_now.to_date
    select 'valeria@email.com', from: 'Responsável'
    click_on 'Criar Tarefa'

    expect(page).to have_content('Tarefa criada com sucesso')
    expect(page).to have_content("Autor: #{current_user.email}")
    expect(page).to have_content('Responsável: valeria@email.com')
    expect(page).to have_content('Título: Bugfix do projeto')
    expect(page).to have_content('Descrição: Conserta o erro tal do arquivo tal')
    expect(page).to have_content("Prazo: #{10.days.from_now}")
  end
end
