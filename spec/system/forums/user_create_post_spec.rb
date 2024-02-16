require 'rails_helper'

describe 'Usuário cria postagem' do
  it 'com sucesso' do
    user = create(:user)
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    page.refresh
    click_on 'Fórum'
    fill_in 'Título', with: 'Postagem inicial'
    fill_in 'Corpo', with: 'Vamos falar sobre'
    click_on 'Postar'

    page.refresh

    expect(page).to have_current_path project_forum_path(project)
    expect(page).to have_content 'Fórum'
    expect(page).to have_content 'Postagem inicial'
    expect(page).to have_content 'Vamos falar sobre'
    expect(page).to have_content "por #{user.full_name}"
    expect(Post.count).to eq 1
  end
end
