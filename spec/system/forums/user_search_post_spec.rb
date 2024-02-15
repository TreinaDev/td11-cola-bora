require 'rails_helper'

describe 'Usuário vê página de fórum de um projeto' do
  it 'a partir da tela inicial' do
    user = create(:user)
    project = create(:project, user:)
    user_role = user.user_roles.first
    create(:post, user_role:, project:, title: 'Postagem inicial')
    create(:post, user_role:, project:, title: 'Como ajustar tarefas iniciadas')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'Pesquisar', with: 'Como'

    expect(page).to have_content 'Como ajustar tarefas iniciadas'
    expect(page).not_to have_content 'Postagem inicial'
  end

  it 'a partir da tela inicial' do
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
