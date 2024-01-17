require 'rails_helper'

describe 'Usuário cria um projeto' do
  it 'e deve estar autenticado' do
    visit new_project_path

    expect(current_path).to eq new_user_session_path
    # Para continuar, faça login ou registre-se
    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end

  it 'a partir da home' do
    user = create :user

    login_as(user)
    visit(root_path)
    click_on 'Criar Projeto'

    expect(page).to have_field 'Title'
    expect(page).to have_field 'Description'
    expect(page).to have_field 'Category'
    expect(page).to have_button 'Criar Projeto'
  end

  pending 'com sucesso'

  pending 'com campos vazios'
end
