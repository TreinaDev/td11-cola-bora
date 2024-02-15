require 'rails_helper'

describe 'Usuário vê página de fórum de um projeto' do
  it 'a partir da tela inicial' do
    user = create(:user)
    project = create(:project, user:)
    user_role = user.user_roles.first
    create(:post, user_role:, project:, title: 'Postagem inicial')

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'

    expect(page).to have_content 'Postagem inicial'
  end
end