require 'rails_helper'

describe 'Usuário faz pesquisa' do
  it 'e vê postagens filtradas' do
    user = create(:user)
    project = create(:project, user:)
    user_role = user.user_roles.first
    create(:post, user_role:, project:, title: 'Postagem inicial')
    create(:post, user_role:, project:, title: '5 passos da reunião', body: 'Já se perguntou como iniciar?')
    create(:post, user_role:, project:, title: 'Como ajustar tarefas iniciadas?')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'Pesquisar', with: 'Como'

    expect(page).to have_content 'Como ajustar tarefas iniciadas'
    expect(page).to have_content '5 passos da reunião'
    expect(page).not_to have_content 'Postagem inicial'
  end

  it 'e não há postagem para pesquisa' do
    user = create(:user)
    project = create(:project, user:)
    user_role = user.user_roles.first
    create(:post, user_role:, project:, title: 'Postagem inicial')
    create(:post, user_role:, project:, title: 'Como ajustar tarefas iniciadas')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'Pesquisar', with: 'Como fazer um rôdo?'

    expect(page).not_to have_content 'Como ajustar tarefas iniciadas'
    expect(page).not_to have_content 'Postagem inicial'
    expect(page).to have_content 'Não existem postagens.'
  end
end
