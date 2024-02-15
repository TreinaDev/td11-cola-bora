require 'rails_helper'

describe 'Usuário vê página de fórum de um projeto' do
  it 'a partir da tela inicial' do
    user = create(:user)
    project = create(:project, user:)
    user_role = user.user_roles.first
    create(:post, user_role:, project:, title: 'Postagem inicial', body: 'Bem vindo ao time')
    create(:post, user_role:, project:, title: 'Como vivemos?', body: 'Da melhor maneira')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'

    expect(page).to have_content 'Postagem inicial'
    expect(page).to have_content 'Bem vindo ao time'
    expect(page).to have_content 'Como vivemos?'
    expect(page).to have_content 'Da melhor maneira'
  end
end
