require 'rails_helper'

describe 'Usuário cria um novo tópico no forum' do
  it 'a partir da tela do projeto' do
    user = create(:user)
    project = create(:project, user:)

    login_as(user, scope: :user)
    visit project_path(project)
    click_on 'Fórum'
    fill_in 'title', with: 'Esse é meu jeito de viver'
    fill_in 'body', with: 'De quem nunca que foi igual.'

    click_on 'Postar'

    expect(Post.count).to eq 1
    expect(page).to have_content 'Esse é meu jeito de viver'
    expect(page).to have_content 'De quem nunca que foi igual.'
    expect(page).to have_content 'Postado a menos de um minuto'
    expect(page).to have_content 'por Ash Ketchum'
  end
end
