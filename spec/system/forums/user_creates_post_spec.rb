require 'rails_helper'

describe 'Usuário cria um novo tópico no forum' do
  it 'a partir da tela do projeto', js: true do
    user = create(:user)
    user.profile.update(first_name: 'Ash')
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'Título', with: 'Esse é meu jeito de viver'
    fill_in 'Corpo', with: 'De quem nunca que foi igual.'

    click_button 'Postar'

    expect(Post.count).to eq 1
    expect(page).to have_content 'Esse é meu jeito de viver'
    expect(page).to have_content 'De quem nunca que foi igual.'
    expect(page).to have_content 'por Ash'
  end

  it 'e deixa campos em branco', js: true do
    user = create(:user)
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'Título', with: ''
    fill_in 'Corpo', with: ''

    click_button 'Postar'

    expect(Post.count).to eq 0
    expect(page).to have_content 'Título não pode ficar em branco'
    expect(page).to have_content 'Corpo não pode ficar em branco'
  end
end
