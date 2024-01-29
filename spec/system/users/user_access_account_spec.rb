require 'rails_helper'

describe 'Usuário acessa página de login' do
  it 'e faz login com sucesso' do
    create(:user, email: 'usuario@email.com', password: '123456')

    visit root_path
    within 'nav' do
      click_on 'Entrar'
    end
    within 'form' do
      fill_in 'E-mail', with: 'usuario@email.com'
      fill_in 'Senha', with: '123456'
      click_on 'Entrar'
    end

    expect(page).to have_content 'Login efetuado com sucesso.'
    within '#navbar' do
      expect(page).to have_button 'Sair'
      expect(page).to have_content 'usuario@email.com'
      expect(page).not_to have_link 'Entrar'
    end
  end

  it 'e não faz login com dados incorretos' do
    create(:user, email: 'usuario@email.com', password: '123456')

    visit new_user_session_path
    within 'form' do
      fill_in 'E-mail', with: 'email_errado@email.com'
      fill_in 'Senha', with: 'senha_errada'
      click_on 'Entrar'
    end

    expect(page).to have_content 'E-mail ou senha inválidos.'
    expect(page).to have_current_path new_user_session_path
  end
end
