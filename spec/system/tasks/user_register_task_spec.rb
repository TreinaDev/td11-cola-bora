require 'rails_helper'

describe 'Usuário cria tarefa' do
  it 'á partir da pagina princial do projeto' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    create(:user, email: 'valeria@email.com', password: 'password', cpf: '000.000.001-91')
    project = create(:project, user: author)

    login_as(author)
    visit project_path(project)
    click_on 'Tarefas'
    click_on 'Nova Tarefa'
    fill_in 'Título', with: 'Bugfix do projeto'
    fill_in 'Descrição', with: 'Conserta o erro tal do arquivo tal'
    fill_in 'Prazo', with: 10.days.from_now.to_date
    select 'valeria@email.com', from: 'Responsável'
    click_on 'Salvar'

    expect(page).to have_content('Tarefa criada com sucesso')
    expect(page).to have_content("Autor\n#{author.email}")
    expect(page).to have_content('Tarefa: Bugfix do projeto')
    expect(page).to have_content("Prazo\n#{I18n.l 10.days.from_now.to_date}")
    expect(page).to have_content("Responsável\nvaleria@email.com")
    expect(page).to have_content("Descrição\nConserta o erro tal do arquivo tal")
  end

  it 'e a criação falha pois os campos estão em branco' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    create(:user, email: 'valeria@email.com', password: 'password', cpf: '000.000.001-91')
    project = create(:project, user: author)

    login_as(author)
    visit project_path(project)
    click_on 'Tarefas'
    click_on 'Nova Tarefa'
    fill_in 'Título', with: ''
    click_on 'Salvar'

    expect(page).to have_content('Não foi possível criar a tarefa.')
    expect(page).to have_content('Título não pode ficar em branco')
    expect(current_path).to eq new_project_task_path(project)
    expect(page).to have_field 'Título'
  end

  it 'e tem que estar autenticado' do
    author = create(:user, email: 'joão@email.com', password: 'password')
    create(:user, email: 'valeria@email.com', password: 'password', cpf: '000.000.001-91')
    project = create(:project, user: author)

    visit project_path(project)

    expect(page).to have_content('Para continuar, faça login ou registre-se.')
    expect(current_path).to eq new_user_session_path
  end
end
